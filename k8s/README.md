- [@sample-django](https://github.com/digitalocean/sample-django/tree/main) deployment to AWS EKS using Terraform for provisioning infrastructure and Helm Chart for deployment and managment of applications on K8s cluster.

## Familiarize with Kubernetes and Helm

Kubernetes is a powerful container orchestration platform that automates the deployment, scaling, and management of containerized applications. It provides features like service discovery, load balancing, and automated rollouts and rollbacks.

Helm is a package manager for Kubernetes that simplifies the deployment and management of applications on Kubernetes clusters. It uses charts, which are packages of pre-configured Kubernetes resources, to define, install, and upgrade complex Kubernetes applications.

## Create Helm chart for the application
We'll create a Helm chart for the Django application with the following components:

ConfigMap: To store environment variables.
Secret: To securely store sensitive information like database passwords.

Deployment: Defines how many replicas of the application to run, container configuration, probes, and environment variables.

Service: Exposes the application internally within the Kubernetes cluster.

Ingress: To route external traffic to the application and configure a Load Balancer.

CertManager: To automatically obtain TLS certificates from Let's Encrypt for HTTPS.

HorizontalPodAutoscaler: Automatically scales the application based on CPU or RAM usage.

## Prepare helmfile for deploying the environment:
Helmfile is a declarative specification for deploying Helm charts. It allows us to define multiple Helm releases and manage their dependencies. We'll use helmfile to manage the deployment of our Helm chart along with any additional configurations needed.

## Benefits of Kubernetes and Helm:
Scalability: Kubernetes allows us to scale our application horizontally by adding or removing pods based on demand. Helm simplifies the management of these scalable deployments by providing a package manager-like interface.

Portability: Kubernetes abstracts away the underlying infrastructure, allowing the application to run consistently across different environments. Helm charts further enhance portability by packaging all necessary configurations and dependencies in a single package.

Automation: Kubernetes automates many tasks involved in deploying and managing applications, such as load balancing, scaling, and rolling updates. Helm extends this automation by providing a templating engine for defining Kubernetes manifests, making it easier to deploy complex applications.

Consistency: With Helm charts, we can define our application's configuration in a version-controlled format, ensuring consistency across different environments and deployments.

By leveraging Kubernetes and Helm, we can efficiently deploy and manage the client's Django application while ensuring scalability, portability, and automation.






## Deployment of a Kubernetes Cluster and Application Using Terraform and AWS EKS

After provisioning resources in AWS with Terraform, we need to update the kubeconfig file on your local machine to configure access to an Amazon EKS (Elastic Kubernetes Service) cluster.

To configure access to an EKS run

```bash
  aws eks --region <region> update-kubeconfig --name <cluster_name>
```
After that we need to provision AWS Load Balancer Controller with Helm

```bash
helm install aws-load-balancer-controller \
   eks/aws-load-balancer-controller \
   --namespace kube-system \
   --set clusterName=<cluster_name>
```
In addition, we need to create SSL certificate in AWS Certificate Manager for our DNS. After creation, don`t forget to add certificateARN to values.yaml.
Also, we need to configure Route53 to point our DNS to ELB which we created with Helm.

After all, use
```bash
helm install <release_name> .
```
Helm will take the Helm chart located in the current directory and install it onto the Kubernetes cluster under the specified release name.





