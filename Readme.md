## Task 1
Creating a Private GKE cluster and using a hello world Docker file to create an image. Creating the deployment and then create a service
Creating a Private Cluster Using Terraform Code 
Create VPC and Subnets
Creating a service account, artifact registry, firewalls, nat-gateway, cloud storage bucket, router, cloud source repositories using terraform 
giving artifact registry permissions, iam roles
Creating Enabling of APIs

## Creating a private cluster 
1)A private cluster that has private nodes and has no client access to public endpoint.
Creating vpc
Creating subnets
Enabling master authorized networks
master-ipv4-cidr 172.16.0.32/28 specifies an internal IP address range for the control plane (optional for Autopilot). This setting is permanent for this cluster and must be unique within the VPC. The use of non RFC 1918 internal IP addresses is supported.

## Create a terraform.tfvars file and add authorized_source_ranges =  [""] and add your internal IP address so that you can access your cluster with CIDRblock "Your-IPADDRESS"/32

## create a Docker file and push the image to Artifact registry
1) make sure to start your Docker service --- sudo service docker start
2) make sure your docker file is within the folder where the helloworld.html is there
3)DockerFile looks like this if you are using an apache
FROM httpd
COPY . /usr/local/apache2/htdocs/
## building the docker image ---- docker build -t image-name .
4) docker build -t hello-world-service .
## docker run -itd -p 80:80 --name image-secname image-name
5) docker run -itd -p 80:80 --name helloworld hello
6) docker build -t europe-west2-docker.pkg.dev/samplesuji/my-repository/helloworld:ver1 . 
7)docker push europe-west2-docker.pkg.dev/cicdsujana-345110/my-repository/helloworld:ver1

## once the image is pushed to artifact registry
1) make sure you connect to connect your cluster using cluster credentials
2)see if your cluster is working or not by using the command 
kubectl get nodes
3)Once you know your cluster is working you can create deployments and expose it

kubectl apply -f deployment.yaml
kubectl get pods
 once we get pods running expose it
kubectl expose deployment apache --port=80 --target-port=80 --name=test-ser
vice --type=LoadBalancer
## get deployments and services using these comands
kubectl get deployments
kubectl get service



## Task 2
Cloud SQL is google cloud’s managed relational database service for MySQL, PostgreSQL and SQL server. Cloud SQL makes it easy to create and manage database servers in the cloud.
Creating an SQL database and SQL Instance—
As SQL database name should be unique and once we delete the database that database name will be available for 7 days so created a random_id 

## For SQL connection to be secured 
To create a private cloud sql instance on terraform, you need to
1)	Specify the network you want your instance to connect to. You can get information about the network using a datablock, if it already exists or you could create a new network using a resource block using resource "google_compute_network"
2)	Reserve a static internal address for the connection using  resource "google_compute_global_address"
3)	Create the connection via VPC peering using resource "google_service_networking_connection"
4)	Create the instance using resource "google_sql_database_instance"
5)	Create a user in the instance using resource "google_sql_user"
6)	Create a database in the instance using resource "google_sql_database"
7)	In Sql database instance make sure  it depends on google_service_networking_connection
8)	In Ip_configuration add private_network to our private VPC

## Securing the Connectivity between GKE cluster and SQL Database
Authentication can also be done at the pod level, using something called workload identity.

Workload identity allows pods to have their own service account. This way they dont need the node’s service account. Each pod can authenticate directly to GCP services and be assigned only the set of permissions it needs to operate.
Workload identity allows mapping of a kubernetes service account to a google service account and uses the concept of workload identity pools for clusters, to enable IAM recognize kubernetes service credentials. The default node pool for a cluster is project_id.svc.id.googso that each kubernetes service account in that cluster can be authenticated as
serviceAccount:project_id.svc.goog[kub_ns/kub_sa]

allows kubernetes service account authenticate as a google service account
  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }
1)	Create a Kubernetes provider  ---    provider "kubernetes"
2)	Create IAMService account  to the Cloud SQL Instance which will be associated with Kubernetes service account using resource "kubernetes_service_account"
3)	binds the kubernetes service account to the google service account
4)	bind the Kubernetes service to the necessary IAM roles
5)	We can see that the Multiples zones option is enabled to ensure high-availability -- if required
6)	add an annotation with the google service account email to Kubernetes service account
7)	Every Kubernetes service account must be associated with a Kubernetes namespace 
8)	Export the cluster ca certificate to a cloud storage bucket
9)	Export cluster endpoint to a cloud storage bucket




BINDING KSA to GSA
members = [
    "serviceAccount:${var.project}.svc.id.goog[${kubernetes_namespace.dev.metadata[0].name}/${kubernetes_service_account.kube_sa.metadata[0].name}]"
  ]

## Blob Store
After Successfully connecting GKE and SQL Database now we have to make sure the data is stored in Storage bucket safely
1)	Export the cloud sql instance connection name to a cloud storage bucket
2)	export the database user name to a cloud storage bucket
3)	export the database user password to a cloud storage bucket
4)	export the database name to a cloud storage bucket
5)	get cluster endpoint from cloud storage
6)	get cluster certificate from cloud storage
7)	get the name of the sql instance database from a cloud storage bucket


## Task 3
The Applications scales based on the traffic and in Container node pool autoscaling is set with minimum node count and maximum node count.

## Task 4
As the cluster has auto scaling enabled so when there is no traffic automatically the nodes scale down which reduces the cost.
Use dedicated node pools -----cluster can increase needs node and decrease nodes based upon the travel----node autoprovisioning ---create node pools and split up application based on labels,selectors,taints

Billing alerts has been placed and notifications will be sent to either email or slack
Monitoring Alert is in place

## Task 5 
In a world of data breaches, I have implemented DLP 
DLP is nothing but Data loss Prevention.
DLP is performed using Masking techniques 
Here I am using cloud DLP using information types – Info type is nothing but a sensitive data such as name, email address , credit card numbers
So for example if I want to remove email address from block of text/file , I mention the custome type email address and eradicate it.


## Cloud Build CI/CD
Accessing Private GKE cluster with Cloud Build private pools
Doing a CI/CD with public cluster is very easy just buy using cloudbuild.yaml file
Whereas when it is a private gke cluster everything changes as security ascpect kicks in.
Only a private pool workers can communicate with private GKE cluster or SQL database
VPN allow workers in a cloud build private pool to access the control plane of a private GKE cluster.


For CI/CD to happen
1)	I have created or setup a cloud build private pool using resource "google_cloudbuild_worker_pool"
2)	Creating a vpc for private pool both the vpc’s should be in the same project
3)	Connecting the Private pool network with private pool vpc google_compute_network_peering
4)	Vpc network peering happens automatically when you create the GKE cluster 
5)	Creating a cloud VPN connection between your two vpc networks
6)	Create two gateways one for each vpc. One for private gke vpc and one for private pool vpc
7)	Create 2 routers using google_compute_router   router 1 and router 2
8)	For those 2 router we have to do router peering using google_computer_router_peer. Router1_peer1, Router1_peer2, Router2_peer1,Router2_peer2
9)	Create VPN Tunnels for each router we have to create 2 tunnels. So for 2 routers we need to create total 4 tunnels

Once the VPN connection between the two VPC networks is established enable cloud build access to GKE control plane.
By giving I am policy binding 


## Files attached and what each file does

apisenable.tf   	enabling all the apis required for this particular project

artifactregistry.tf 	creating artifact registry to store the images and giving permission to the registry with service account

billing-monitoring.tf   	creating billing budget and monitoring notification channel
	monitoring alert policy

cloudbuild_tigger.tf	creating cloudbuild trigger for cloudbuild.yaml

cluster.tf	creating a private cluster and google container node pool

datalossprevention.tf	creating DLP stored info type and sensors

deployment.yaml	creating Kubernetes deployment

dockerfile 	hello world image ubuntu and Debian

Kubernetes.tf	creating Kubernetes namespace ,service account for Kubernetes and binding workload identity

Mysql_db.tf	creating sqldatabase instance ,sql database and user for adming

Privatepool_vpcpeering.tf	creating service networking , service network connection , service peering address using global address

Providers.tf	Kubernetes provider

Serviceaccount.tf	google service account for gke and Kubernetes service account, binding k8s service account to necessary iam roles, creating service key, iam policies

Sourcerepo.tf	create cloud source repo
Storagebucket.tf	creating storage bucket, storage bucket objects, storage bucket object content

VPC	create vpc and subnets


## These files they are used for cloudbuild
v.deploy.tf.old 	Kubernetes deployment
v.expose.tf0	kubernetes service
v.gateway-havpn.tf0  	created 2 gateways
v.router.tf	creating cloud routers
v.router_interface.tf0 	interface for router with vpn tunnel in it
v.router_peer.tf0 	peering for routers
v.tunnel.tf0	tunneling using router and gateways

 
	

 

