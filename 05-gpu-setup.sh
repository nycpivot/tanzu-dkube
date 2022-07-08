#!bin/bash

read -p "Docker Username: " docker_user
read -p "Docker Password: " docker_pass
read -p "DKube Version (3.2.0.1): " dkube_version
read -p "GPU Node IP1: " ip1
read -p "GPU Node IP2: " ip2

if [[ -z $dkube_version ]]
then
	dkube_version=3.2.0.1
fi

sudo apt update
yes | sudo apt upgrade
yes | sudo apt install docker.io

sudo docker login -u $docker_user -p $docker_pass
sudo docker run --rm -it -v $HOME/.dkube:/root/.dkube ocdr/dkubeadm:${dkube_version} init

cd .dkube

rm k8s.ini
cat <<EOF | tee k8s.ini
# Configuration types: basic or advanced
# For basic, below configuration are used for managing cluster.
# For advance, k8s-advanced.ini file is read for configurations.
[configuration]
mode=basic

# Kubernetes Deployment Information
[deployment]
# Possible values 'onprem', 'gcp', 'gke', okd, 'aws', 'eks', 'ntnx', 'tanzu'
provider=tanzu
# Possible values are 'ubuntu', 'centos'
distro=ubuntu
# Schedule pods to master node. 'false' to make master unschedulable.
master=true
# Create HA cluster with 3 masters. 'true' to enable HA
master_HA=false
# When HA=true k8s cluster must have min 3 schedulable nodes
HA=false

# IP address of all the nodes that make up cluster
# Make sure these IP address are publicly reachable
# For AWS, GCP VMs make sure these IPs are static
# First node will be used for master & etcd, remaining for workers
[nodes]
#<public-ip [private-ip]>
#<hostname> [private-ip]>
#192.168.1.20 10.0.0.20
#192.168.1.30
$ip1
$ip2

[STORAGE]
# Type of storage
# Possible values: disk, pv, sc, nfs
# Following are required fields for corresponding storage type
#    -------------------------------------------------------
#    STORAGE_TYPE    REQUIRED_FIELDS
#    -------------------------------------------------------
#    disk            STORAGE_DISK_NODE and STORAGE_DISK_PATH
#    pv              STORAGE_PV
#    sc              STORAGE_SC
#    nfs             STORAGE_NFS_SERVER and STORAGE_NFS_PATH
#    ceph            STORAGE_CEPH_FILESYSTEM and STORAGE_CEPH_NAMESPACE

STORAGE_TYPE=disk

# Ceph data and configuration path for internal ceph
# Internal ceph is installed when HA=true and STORAGE_TYPE is not in ("nfs", "ceph")
STORAGE_CEPH_PATH=/var/lib/rook

# ssh user for accessing above nodes passwordlessly
[ssh-user]
user=ubuntu
EOF

sudo rm ssh-rsa
sudo rm ssh-rsa.pub

sudo vim ssh-rsa

sudo ./dkubeadm node setup
