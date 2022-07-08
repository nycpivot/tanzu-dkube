#!bin/bash

aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | .PublicIpAddress'+\"\ \"+(.Tags[] | select(.Key == \"Name\").Value) | grep bastion

read -p "Bastion IP: " bastion_ip

aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | .PrivateIpAddress'+\"\ \"+(.Tags[] | select(.Key == \"Name\").Value) | grep gpu

echo
cat tanzu-operations-us-east-1.pem
echo

ssh $bastion_ip -i tanzu-operations-us-east-1.pem
git clone https://github.com/nycpivot/tanzu-dkube.git

bash tanzu-dkube/05-gpu-setup.sh

