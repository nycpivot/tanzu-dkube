#!bin/bash

sudo apt update
sudo apt install docker.io

sudo docker login -u $docker_user -p $docker_pass
sudo docker run --rm -it -v $HOME/.dkube:/root/.dkube ocdr/dkubeadm:${dkube_version} init

sudo ./dkubeadm node setup