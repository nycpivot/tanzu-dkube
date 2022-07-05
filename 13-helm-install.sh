#!bin/bash

read -p "Cluster Name: " cluster_name

kubectl config use-context ${cluster_name}-admin@${cluster_name}

helm repo add dkube-helm https://oneconvergence.github.io/dkube-helm
helm repo update

helm show values dkube-helm/dkube-deployer > values.yaml
