output "route_table_name" {
  description = "The name of the Azure Route Table"
  value       = azurerm_route_table.main.name
}

output "route_table_id" {
  description = "The ID of the Azure Route Table"
  value       = azurerm_route_table.main.id
}