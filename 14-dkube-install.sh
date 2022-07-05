#!bin/bash

#FOR VALUES, GOTO https://dkube.io/unlinked/install2_1/Install-Advanced.html#install-advanced

vim values.yaml

helm install -f values.yaml tanzu-dkube dkube-helm/dkube-deployer

kubectl wait --for=condition=ready --timeout=5m pod -l job-name=dkube-helm-installer
kubectl logs -l job-name=dkube-helm-installer --follow --tail=-1 && kubectl wait --for=condition=complete --timeout=30m job/dkube-helm-installer

