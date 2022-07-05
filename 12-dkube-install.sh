#!bin/bash

read -p "Cluster Name: " cluster_name
read -p "Docker Username: " docker_user
read -p "Docker Password: " docker_pass
read -p "DKube Version (3.2.0.1): " dkube_version

if [[ -z $dkube_version ]]
then
	dkube_version=3.2.0.1
fi

sudo apt update
sudo apt install docker.io

sudo docker login -u $docker_user -p $docker_pass
sudo docker run --rm -it -v $HOME/.dkube:/root/.dkube ocdr/dkubeadm:${dkube_version} init

kubectl config use-context ${cluster_name}-admin@${cluster_name}

helm repo add dkube-helm https://oneconvergence.github.io/dkube-helm
helm repo update
#helm show values dkube-helm/dkube-deployer | sudo bash -c 'cat - > values.yaml'
helm show values dkube-helm/dkube-deployer > values.yaml

#FOR VALUES, GOTO https://dkube.io/unlinked/install2_1/Install-Advanced.html#install-advanced

helm install -f values.yaml tanzu-dkube dkube-helm/dkube-deployer


kubectl patch svc istio-ingressgateway -n istio-system  -p '{"spec":{"type":"LoadBalancer"}}'
kubectl -n istio-system get svc istio-ingressgateway


#GPU (login to bastion host)

sudo docker login -u $docker_user -p $docker_pass
sudo docker run --rm -it -v $HOME/.dkube:/root/.dkube ocdr/dkubeadm:${dkube_version} init

name: tanzu-dkube-gpu
replicas: 2
az: us-east-1a
nodeMachineType: g4dn.4xlarge
labels:
  dkube: gpu
	
tanzu cluster node-pool set tanzu-dkube-demo -f gpu-config.yaml
tanzu cluster node-pool list tanzu-dkube-demo