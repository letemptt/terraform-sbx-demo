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
  default     = "westus2"
}
variable "secondary_region" {
  description = "Secondary region to deploy resources into"
  type        = string
  default     = "eastus"
}