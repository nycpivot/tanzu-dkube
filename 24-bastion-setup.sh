#!bin/bash

read -p "Docker Username: " docker_user
read -p "Docker Password: " docker_pass
read -p "DKube Version (3.2.0.1): " dkube_version

if [[ -z $dkube_version ]]
then
	dkube_version=3.2.0.1
fi

sudo apt update
yes | sudo apt upgrade
yes | sudo apt install docker.io

sudo docker login -u $docker_user -p $docker_pass
sudo docker run --rm -it -v $HOME/.dkube:/root/.dkube ocdr/dkubeadm:${dkube_version} init
