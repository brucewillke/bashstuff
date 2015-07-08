#!/bin/bash

BACKUP_PATH="/tmp/route53backups"
ZONES_FILE="all-zones.bak"
DNS_FILE="all-dns.bak"

mkdir -p "$BACKUP_PATH"
cd "$BACKUP_PATH"


/usr/local/bin/cli53 list > "$ZONES_FILE" 2>&1


sed '/Name:/!d' "$ZONES_FILE"|cut -d: -f2|sed 's/^.//'|sed 's/.$//' > "$DNS_FILE"

while read -r line; do
        /usr/local/bin/cli53 export --full "$line" > "$line.bak"
done < "$DNS_FILE"


tar cvfz "$BACKUP_PATH.tgz" "$BACKUP_PATH"

/usr/local/bin/s3cmd put /tmp/route53backups.tgz "s3://backups/route53backups/$(date +"%m-%d-%y")-route53.tgz"

if [ $? -ne 0 ]
then
 curl -X POST --data-urlencode 'payload={"channel": "#sysops-notifications", "username": "webhookbot", "text": "The ROUTE53 backup did not complete.", "icon_emoji": ":ghost:"}' https://hooks.slack.com/services/REDACTED
fi

