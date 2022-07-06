#!bin/bash

helm repo add dkube-helm https://oneconvergence.github.io/dkube-helm
helm repo update

helm show values dkube-helm/dkube-deployer > values.yaml
