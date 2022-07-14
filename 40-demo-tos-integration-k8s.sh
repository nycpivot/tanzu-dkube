#!/bin/bash

########################
# include the magic
########################
. demo-magic.sh

########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
TYPE_SPEED=20

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
#DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# hide the evidence
clear


#CUSTOM POLICY
DEMO_PROMPT="${GREEN}➜ TOS ${CYAN}\W "
echo

development_cluster=tanzu-dkube-admin@tanzu-dkube

pe "tmc cluster integration create -f tanzu-dkube/configs/integration-wavefront.yaml"
echo


#ADD TO PRODUCTION CLUSTER
#pe "kubectl config use-context ${development_cluster}"
#echo

#pe "kubectl apply -f tmc/configs/tos-node-stressor.yaml"