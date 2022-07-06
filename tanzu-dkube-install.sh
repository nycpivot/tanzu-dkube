#!/bin/bash

kubectl config get-contexts

read -p "Context: " context

kubectl config use-context $context

bash 12-node-pool-add.sh
bash 21-docker-pull.sh
bash 22-helm-install.sh
bash 23-dkube-install.sh

