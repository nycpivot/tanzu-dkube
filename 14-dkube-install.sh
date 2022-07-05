#!bin/bash

#FOR VALUES, GOTO https://dkube.io/unlinked/install2_1/Install-Advanced.html#install-advanced

vim values.yaml

helm install -f values.yaml tanzu-dkube dkube-helm/dkube-deployer

kubectl patch svc istio-ingressgateway -n istio-system  -p '{"spec":{"type":"LoadBalancer"}}'
kubectl -n istio-system get svc istio-ingressgateway
