# vm-selfsufficien-deployment
The repository includes all the files to enable end to end vm deployment by separating the Azure account details and the VM credentials from main.tf file..

These files will enable:
1.	 Connecting and authenticating with Azure using credentials and the cloud subscription account details stored in a variables.tf file. 
2.	The main.tf template will provision a self-sufficient VM which does not need the VM credentials stored (hard coded) in the file. This will enable providing a unique account name and password for the VM administrator account for every deployment.
3.	An end user will set the credentials of the VM being provisioned, the VM deployment region, and a prefix to the resources being provisioned.
4.	It saves the environment state locally (at end user machine).

Dependencies:
1.	Active Azure tenancy and a subscription is required.
2.	Terraform is installed and configured on the end user machine.
3.	Terraform application registration with Azure should be in place before executing the provisioning.

If you are new to Terraform, then follow the steps below to provision the VM:
1.	Run the following commands in sequence from your PowerShell or MacOS Terminal to complete the deployment of the VM and associated resources
a.	terraform init
b.	terraform plan -out=newplan
i.	Set the VM admin user account password
ii.	Set the VM admin user account name
iii.	Set the Azure Region to deploy the VM (e.g., australiaeast)
iv.	Set the environment resource variable prefix (e.g. prddb)
The command will show details of 10 new resources which will be provisioned. This is a planning phase and no resources will be provisioned at this stage. 
c.	terraform apply newplan
The script will provision all the 10 new resources in less than 3 minutes.

2.	Run the following command from your PowerShell or MacOS Terminal to see the details of all the resources provisioned in your terminal screen
terraform show
	You can also validate the resource deployment through Azure Portal.

3.	Run the following command from your PowerShell or MacOS Terminal to destroy the provisioned environment (the vm and all the associated resources will be destroyed) 
terraform destroy (to see details of all the provisioned resources)

The script will prompt you to provide previously provided details and a confirmation “Yes” to destroy the environment before it initiates the process of removing all the resources. 


