# # Azure Kubernetes Service (AKS) with System Assigned Identity
# resource "azurerm_kubernetes_cluster" "aks" {
#   name                = "${var.prefix}aks"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   dns_prefix          = "${var.prefix}aks"
#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_D2_v2"
#   }
#   identity {
#     type = "SystemAssigned"
#   }

#   tags = {
#     Environment = "Sbx"
#   }
# }

# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
#   sensitive = true
# }

# output "kube_config" {
#   value = azurerm_kubernetes_cluster.aks.kube_config_raw

#   sensitive = true
# }