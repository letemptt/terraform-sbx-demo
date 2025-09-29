#
# Variables for configuration and secrets
#
# These variables are all satisfied in the example file secrets.tfvars.template
#

# ----------------------------------------
# Azure target configuration
# ----------------------------------------

# Service principal authentication
# Azure Service Principal ID and secret
variable "client_id" {
  description = "Azure service principal ID"
  type        = string
}
variable "client_secret" {
  description = "value of the Azure service principal secret"
  type        = string
}

# Azure tenant and subscription
variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

# Target resource group and region
variable "resource_group_name" {
  description = "Name of the resource group to deploy"
  type        = string
  validation {
   condition     = length(var.resource_group_name) > 3 && substr(var.resource_group_name, 0, 3) == "rg-"
    error_message = "The resource_group_name must start with \"rg-\"."
  }
}
variable "resource_group_region" {
  description = "Primary region to deploy resources into"
  type        = string
}

# Notification email
variable "notification_email" {
  description = "Email address for notifications"
  type        = string
}



# ----------------------------------------
# Feature stanza
# ----------------------------------------

variable "prefix" {
  description = "Prefix for Azure Machine Learning resources"
  type        = string
}

# ----------------------------------------
# Azure AI Search Service Variables
# ----------------------------------------
variable "sku" {
  type        = string
  description = "The SKU of the Azure Search service."
  default     = "standard"
}

variable "replica_count" {
  type        = number
  description = "The number of replicas for the Azure Search service."
  default     = 1
}

variable "partition_count" {
  type        = number
  description = "The number of partitions for the Azure Search service."
  default     = 1
}
variable "primary_region" {
  description = "Primary region to deploy resources into"
  type        = string
  default     = "westus3"
}
variable "secondary_region" {
  description = "Secondary region to deploy resources into"
  type        = string
  default     = "westus"
}

#-----------------------------------------
# Azure MongoDB Variables
#-----------------------------------------
variable "mongoAdminUsername" {
  description = "MongoDB administrator username"
  type        = string
  default     = "mongoAdmin"
}

variable "mongoAdminPassword" {
  description = "MongoDB administrator password"
  type        = string
  sensitive = true
}

#-----------------------------------------
# Azure VNET Variables
#-----------------------------------------

variable "vnet_address_prefix" {
  description = "Address space for the virtual network in CIDR notation"
  type        = string
  default     = "10.0.0.0/21"  # /21 provides 2,048 IP addresses
  
  validation {
    condition     = can(cidrnetmask(var.vnet_address_prefix))
    error_message = "The vnet_address_prefix must be a valid CIDR notation."
  }
}

variable "subnet_service_endpoints" {
  description = "List of service endpoints to enable for the subnets"
  type        = list(string)
  default     = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureCosmosDB"]
}

#-----------------------------------------
# Azure TAGS Variables
#-----------------------------------------

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
#-----------------------------------------
# Azure APP Service Variables
#-----------------------------------------
variable "linuxFxVersion" {
  description = "LinuxVersion for the App Service"
  type        = string
  default     = "DOTNETCORE|7.0"
}