# udacity-devops
udacity-devops

The Udacity Project 1.

Overview:
- Azure Policy: Create "Required tags when create a resource" policy.
- Packer: create Linux VM based on Ubuntu 18.04 LTS
- Terraform: create Vnet, Subnet, IP Pulic, NIC, Linux-VM (use Image from Packer)

How to run:
- Azure policy:
    + az account set --subscription <your_subcription_id>
    + az policy definition create --name "RequireTags" --display-name "Require Tags on Resources" --description "This policy ensures that all resources are created with tags." --rules tagspolicy.json
    + az policy assignment create --name "RequireTagsAssignment" --display-name "Require Tags on Resources Assignment" --scope "/subscriptions/<subscription_id_or_name>" --policy "RequireTags
    + az policy assignment list
- Packer (server.json): 
    + packer plugins install github.com/hashicorp/azure
    + replace : subscription_id, client_id, client_secret with your crential.
    + packer build server.json
- Terraform:
    + terraform init
    + terraform plan
    + terraform apply
    + terraform destroy

All variables used in Terraform are defined in the variables.tf file. Each variable has a description.