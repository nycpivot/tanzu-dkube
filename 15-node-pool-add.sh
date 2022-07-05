#!bin/bash

rm gpu-config.yaml
cat <<EOF | tee gpu-config.yaml
name: tanzu-dkube-gpu
replicas: 2
az: us-east-1a
nodeMachineType: g4dn.4xlarge
labels:
  dkube: gpu
EOF
	
tanzu cluster node-pool set tanzu-dkube-demo -f gpu-config.yaml
tanzu cluster node-pool list tanzu-dkube-demo