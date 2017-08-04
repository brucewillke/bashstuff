#!/bin/bash
set -xe

vols=$(/usr/bin/aws ec2 describe-volumes --filters   "Name=status,Values=in-use"   | jq -r ".Volumes[] | .VolumeId")

for a in $vols
do
    /usr/bin/aws ec2 create-snapshot --volume-id $a --description $(/usr/bin/aws ec2 describe-volumes --volume-id $a --query 'Volumes[*].Attachments[*].{ec2instance:InstanceId}' --output text)
done
