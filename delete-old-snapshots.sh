#!/bin/bash
for s in $(old=$(date +%Y-%m-%dT%H:%M:%S%z --date="23 days ago") \
        aws ec2 describe-snapshots \
        --owner-id $1 \
        --query 'Snapshots[?StartTime<=`echo $old`].SnapshotId' --output text);
do
        aws ec2 delete-snapshot --snapshot-id $s
done
