#!/bin/bash

set -xe

aws ec2 describe-snapshots \
--profile $3 \
--owner-id=$1 \
--filters Name=tag-key,Values="Name" Name=tag-value,Values="$2" \
--query 'Snapshots[*].{ID:SnapshotId}' \
--output text > snaps.txt

kms_key_id="alias/aws/ebs"

for s in $(cat snaps.txt);
do
    aws ec2 copy-snapshot \
    --profile baa \
    --source-region us-east-1 \
    --source-snapshot-id $s \
    --encrypted \
    --kms-key-id $kms_key_id \
    --region us-west-2
done
