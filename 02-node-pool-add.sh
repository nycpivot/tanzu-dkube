#!bin/bash

#read -p "Cluster Name: " cluster_name
cluster_name=tanzu-dkube

kubectl config use-context ${cluster_name}-admin@${cluster_name}

rm gpu-config.yaml
cat <<EOF | tee gpu-config.yaml
name: tanzu-dkube-gpu
replicas: 2
az: us-east-1a
nodeMachineType: g4dn.4xlarge
labels:
  dkube: gpu
EOF
	
tanzu cluster node-pool set $cluster_name -f gpu-config.yaml
tanzu cluster node-pool list $cluster_name

