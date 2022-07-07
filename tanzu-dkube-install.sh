#!/bin/bash

kubectl config get-contexts

read -p "Context: " context

kubectl config use-context $context

bash 12-node-pool-add.sh
bash 21-dkube-install.sh
bash 22-gpu-setup.sh

