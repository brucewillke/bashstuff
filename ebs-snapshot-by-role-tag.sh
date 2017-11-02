#!/bin/bash
ROLE="$1"

ATTACHEDVOLUME=$(/usr/local/bin/aws ec2 describe-instances \
--filters 'Name=tag:Role',Values=$ROLE \
--query 'Reservations[*].Instances[*].BlockDeviceMappings[?DeviceName==`/dev/xvdb`]'.Ebs.VolumeId \
--output text)

echo $ATTACHEDVOLUME

for volid in $ATTACHEDVOLUME
do
    echo "###snapshotting $volid###"; /usr/local/bin/aws ec2 create-snapshot --volume-id $volid --description ""$ROLE"_$(date +%Y-%m-%d)"
done
