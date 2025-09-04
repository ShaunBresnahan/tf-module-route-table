output "route_table_name" {
  description = "The name of the Azure Route Table"
  value       = azurerm_route_table.main.name
}