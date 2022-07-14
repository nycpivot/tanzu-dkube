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

development_cluster_group=development-cluster-group
development_cluster=tanzu-dkube-admin@tanzu-dkube


DEMO_PROMPT="${GREEN}➜ TMC ${CYAN}\W "
echo

#CREATE PRODUCTION CLUSTER GROUP
pe "tmc clustergroup create --name ${development_cluster_group}"
echo

#ATTACH PRODUCTION CLUSTER MANUALLY
pe "kubectl config use-context ${development_cluster}"
echo

read -p "Retrieve command from portal: " attach_command

pe "${attach_command}"
echo

pe "clear"

