#CLUSTER GROUPS
development_cluster_group=development-cluster-group

#CLUSTERS
development_cluster=tanzu-dkube

#DELETE POLICIES
tmc clustergroup namespace-quota-policy delete quota-policy --cluster-group-name $development_cluster_group

#DELETE INTEGRATIONS
tmc cluster integration delete tanzu-observability-saas --cluster-name $development_cluster --management-cluster-name attached --provisioner-name attached

#DELETE CLUSTERS
tmc cluster delete $development_cluster --management-cluster-name attached --provisioner-name attached


read -p "Enter to continue"

#DELETE CLUSTER GROUPS
tmc clustergroup delete $development_cluster_group
