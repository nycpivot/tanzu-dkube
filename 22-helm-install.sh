#!bin/bash

read -p "Registry Username: " user
read -p "Registry Password: " pass

helm repo add dkube-helm https://oneconvergence.github.io/dkube-helm
helm repo update

#helm show values dkube-helm/dkube-deployer > values.yaml

rm values.yaml
cat <<EOF | tee values.yaml
# The DKube EULA is available at: www.oneconvergence.com/EULA/One-Convergence-EULA.pdf
# By accepting this license agreement you acknowledge that you agree to the terms and conditions.
# The installation will only proceed if the EULA is accepted by defining the EULA value as "yes".
EULA: "yes"

# Operator's Local Sign In Details.
# Username cannot be same as that of a kubernetes namespace's name.
# Names like dkube, monitoring, kubeflow are restricted.
username: "admin"
password: "Password#01"

# dkube version
version: "3.2.0.1"

# Choose one of dkube/gke/okd/eks/ntnx/tanzu kube provider
provider: "tanzu"

# For ha deployment, k8s cluster must have min 3 schedulable nodes
ha: "false"

# Wipe dkube data during helm operation install/uninstall.
# Choose one of yes/no
wipedata: "yes"

# To install minimal version of dkube
# Accepted values: yes/no
minimal: "no"

# To install air-gapped version of dkube
# Accepted values: yes/no
airgap: "no"

# Docker registry for DKube installation
registry:
    # Format: registry/[repo]
    name: "docker.io/ocdr"

    # Container registry username
    username: "${user}"

    # Container registry password
    password: "${pass}"

optional:
    storage:
        # Type of storage
        # Possible values: disk, pv, sc, nfs, ceph
        # Following are required fields for corresponding storage type
        #    -------------------------------------------------------
        #    STORAGE_TYPE    REQUIRED_FIELDS
        #    -------------------------------------------------------
        #    disk            node and path
        #    pv              persistentVolume
        #    sc              storageClass
        #    nfs             nfsServer and nfsPath
        #    ceph            cephMonitors and cephSecret
        # For release 2.2.1.12 and later
        #    ceph            cephFilesystem and cephNamespace
        type: "nfs"

        # Localpath on the storage node
        path: "/var/dkube"

        # Nodename of the storage node
        # Possible values: AUTO/<nodename>
        # AUTO - Master node will be chosen for storage if KUBE_PROVIDER=dkube
        node: "AUTO"

        # Name of persistent volume
        persistentVolume: ""

        # Name of storage class name
        # Make sure dynamic provisioner is running for the storage class name
        storageClass: ""

        # NFS server ip
        nfsServer: "10.0.0.175"

        # NFS path (Make sure the path exists)
        nfsPath: "/"

        # Only for external ceph before release 2.2.1.12
        # Comma separated IPs of ceph monitors
        cephMonitors: ""

        # Only for external ceph before release 2.2.1.12
        # Ceph secret
        cephSecret: ""

        # Only for external ceph from release 2.2.1.12
        # Name of the ceph filesystem
        # E.g: dkubefs
        cephFilesystem: ""

        # Only for external ceph from release 2.2.1.12
        # Name of the namespace where ceph is installed
        # E.g: rook-ceph
        cephNamespace: ""

        # Internal Ceph
        # Internal ceph is installed when HA=true and STORAGE_TYPE is not in ("nfs", "ceph")

        # Configuration path for internal ceph
        cephPath: "/var/lib/rook"

        # Only for internal ceph from release 2.2.1.12
        # Disk name for internal ceph storage
        # It should be a raw formatted disk
        # E.g: sdb
        cephDisk: ""

    loadbalancer:
        # Type of dkube proxy service, possible values are nodeport and loadbalancer
        # Please use loadbalancer if kubeProvider is gke.
        access: "nodeport"

        # 'true' - to install MetalLB Loadbalancer
        # Must fill LB_VIP_POOL if true
        metallb: "false"

        # Only CIDR notation is allowed. E.g: 192.168.2.0/24
        # Valid only if installLoadbalancer is true
        vipPool: ""

    modelmonitor:
        #To enable modelmonitor in dkube. (true / false)
        enabled: "false"


    promscale:
        #To enable promscale in dkube. (true / false)
        enabled: "false"

        timescaledb:
            # to use external timescale db
            external: "false"

            # keep it false if db is already existing
            # create: false

            # timescale db | default: timescale
            db: ""

            # database user | default: postgres
            user: ""

            # database password
            password: ""

            # host address of timescale database
            host: ""

            # timescale default port
            port: 5432

            # If external is true backup will not be honored
            backup:

                # to take backup of timescaledb
                enabled: "false"

                # don't fill the details if you want to use internal dkube storage
                s3:

                    # S3 endpont
                    endpoint:

                    # s3 bucket
                    bucket:

                    # path in bucket |  default :/timescale/backups
                    path:

                    # region
                    region:

                    # s3 access key
                    key:

                    # s3 access secret
                    secret:

        #If you want have timescaledb already running you can fill in the below section
        external:

            # To use external promscale set it to true
            enabled: "false"

            # https://docs.timescale.com/promscale/latest/send-data/prometheus/#configure-prometheus-to-read-and-write-data-from-promscale
            # base_url of promsscale hosted service
            base_url: ""

            # read_url prefix | default: /read
            read_url_suffix: ""

            # write_url prefix | default: /write
            write_url_suffix: ""


    DBAAS:
        # To configure external database for dkube
        # Supported mysql, sqlserver(mssql)
        # Empty will pickup default sql db installed with dkube
        database: ""

        # Syntaxes here can be followed to specify dsn https://gorm.io/docs/connecting_to_the_database.html
        dsn: ""

    CICD:
        #To enable tekton cicd with dkube. (true / false)
        enabled: "false"

        #Docker registry where CICD built images will be saved.
        registryName: "docker.io/ocdr"
        registryUsername: ""
        registryPassword: ""

        #For AWS ECR on EKS K8S cluster, enter registry as aws_account_id.dkr.ecr.region.amazonaws.com.
        #registryName: "aws_account_id.dkr.ecr.region.amazonaws.com"
        #Worker nodes should either have AmazonEC2ContainerRegistryFullAccess or if you are using KIAM
        #based IAM control, provide an IAM role which has AmazonEC2ContainerRegistryFullAccess
        #IAMRole: "arn:aws:iam::<aws_account_id>:role/<iam-role>"
        IAMRole: ""

    nodeAffinity:
        # Nodes identified by labels on which the dkube pods must be scheduled.. Say management nodes. Unfilled means no binding. When filled there needs to be minimum of 3nodes in case of HA and one node in case of non-HA
        # Example: DKUBE_NODES_LABEL: key1=value1
        dkubeNodesLabel: ""

        # Nodes to be tolerated by dkube control plane pods so that only they can be scheduled on the nodes
        # Example: DKUBE_NODES_TAINTS: key1=value1:NoSchedule,key2=value2:NoSchedule
        dkubeNodesTaints: ""

        # Taints of the nodes where gpu workloads must be scheduled.
        # Example: GPU_WORKLOADS_TAINTS: key1=value1:NoSchedule,key2=value2:NoSchedule
        gpuWorkloadTaints: ""

        # Taints of the nodes where production workloads must be scheduled.
        # Example: PRODUCTION_WORKLOADS_TAINTS: key1=value1:NoSchedule,key2=value2:NoSchedule
        productionWorkloadTaints: ""

    # Dockerhub Secrets for OCDR images
    # If you don't create, this will be auto-created with default values.
    dkubeDockerhubCredentialsSecret: "dkube-dockerhub-secret"

    # AWS IAM role
    # Valid only if KUBE_PROVIDER=eks
    # This will be set as an annotation in few deployments
    # Format should be like:
    # IAMRole: "<key>: <iam role>"
    # eg: IAMRole: "iam.amazonaws.com/role: arn:aws:iam::123456789012:role/myrole"
    IAMRole: ""
EOF

