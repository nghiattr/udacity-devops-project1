variable "resource_group_name" {
  default     = "Azuredevops"
  description = "Location of the resource group."
}

variable "resource_group_location" {
  default     = "East US"
  description = "Location of the resource group."
}

variable "instance_count" {
  description = "The number of virtual machines to deploy"
  type        = number
  default     = 2
}

variable "custom_tags" {
  description = "custom tags name"
  default     = "NghiaUdacitylab"
}

variable "custom_image_name" {
  default     = "myPackerImage"
  description = "Custom image name"
}

variable "admin_username" {
  default     = "labadmin"
  description = "Admin username for all VMs"
}

variable "admin_password" {
  default     = "Password1234!"
  description = "Admin password for all VMs"
}