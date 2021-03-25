#provider "azurerm" {
#  features {}
#  subscription_id = local.subscription_id 
#}
#
#data "azurerm_resource_group" "main" {
#    depends_on          = [azurerm_resource_group.rg] 
#    name                = local.spokerg   
#}
#
#data "azurerm_subnet" "main" {
#  depends_on = [module.spokesetup]   
#  name = local.spokesubnet
#  resource_group_name  = local.spokerg
#  virtual_network_name = local.spokevnet 
#}
#
#data "azurerm_resource_group" "mainkv" {
#    name = local.spokekv                 
#}
#
#data "azurerm_key_vault" "main" {
#  name                = local.key_vault_name
#  resource_group_name = data.azurerm_resource_group.mainkv.name
#}
#
#data "azurerm_key_vault_certificate" "main" {
#  name         = local.certificate_name
#  key_vault_id = data.azurerm_key_vault.main.id
#}
#
#locals {
#  spokekv                        = "taskmanagerappgateway-RG"
#  spokevnet                      = "Taskmanager-Pre-AG-vnet"
#  spokesubnet                    = "Taskmanager-Pre-AG-subnet"
#  spokerg                        = "m-taskmanager-pre-appgateway-RG"
#  spokepip                       = "Taskmanager-Pre-AG-pip"
#  backend_address_pool_name      = "taskmanager-pre-web-portal-beap"                                      
#  frontend_port_name             = "taskmanager-pre-web-portal-feport"                                    
#  frontend_ip_configuration_name = "taskmanager-pre-web-portal-feip"                                       
#  frontend_ip_configuration_name1= "taskmanager-pre-web-portal-feip-private"
#  private_ip_address             = "10.240.217.10"
#  http_setting_name              = "taskmanager-pre-web-portal-httpset"                                    
#  listener_name                  = "taskmanager-pre-web-portal-listener"                                   
#  request_routing_rule_name      = "taskmanager-pre-web-portal-rqrt"                                       
#  redirect_configuration_name    = "taskmanager-pre-web-portal-rdrcfg"                                     
#  gatewayname                    = "Taskmanager-Pre-appgateway"
#  gatewayipconfigurationname     = "Taskmanager-Pre-gatewayip"
#  subnet_name                    = "Taskmanager-Pre-PE-subnet"
#  vnet_name                      = "Taskmanager-Pre-AG-vnet"
#  key_vault_name                 = "taskmanagerappgateway-kv"
#  gateway_certificate_name       = "Wildcard"
#  certificate_name               = "Wildcard" 
#  managedidentityname            = "mi-taskmanagerappgateway"
#  probe_name                     = "taskmanager-pre-web-portal"
#  probe_host                     = "taskmanager-pre-web-portal.azurewebsites.net"
#  listener_host_name             = "taskmanager-pre-web-portal.engineering.ukho.gov.uk"
#  rewrite_rule_set               = "taskmanager-pre-web-portal-rwset"
#  rewrite_rule                   = "taskmanager-pre-web-portal"
#  pattern                        = "(.*)taskmanager-pre-web-portal.azurewebsites.net(.*)"
#  header_value                   = "{http_resp_Location_1}taskmanager-pre-web-portal.engineering.ukho.gov.uk{http_resp_Location_2}"
#}

#data "azurerm_application_gateway" "example" {
#  name                = "existing-app-gateway"
#  resource_group_name = "existing-resources"
# 
#
#  
#
#output "id" {
#  value = data.azurerm_application_gateway.example.id
#}
#
#  lifecycle {
#    ignore_changes = [
#      tags,
#      ssl_certificate,
#      trusted_root_certificate,
#      frontend_port,
#      backend_address_pool,
#      backend_http_settings,
#      http_listener,
#      url_path_map,
#      request_routing_rule,
#      probe,
#      redirect_configuration,
#      ssl_policy,
#    ]
#  }
#}