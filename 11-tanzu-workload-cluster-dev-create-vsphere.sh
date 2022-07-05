read -p "Cluster Name: " cluster_name

tanzu login

tanzu cluster create $cluster_name --tkr v1.20.14---vmware.1-tkg.4 -f /mnt/c/lab/files/tanzu/tkg-workload-large.conf

rm ${cluster_name}-kubeconfig.yaml

tanzu cluster kubeconfig get $cluster_name --admin
tanzu cluster kubeconfig get $cluster_name --admin --export-file ${cluster_name}-kubeconfig.yaml
