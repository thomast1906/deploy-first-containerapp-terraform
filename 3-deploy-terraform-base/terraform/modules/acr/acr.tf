resource "azurerm_container_registry" "acr" {
  name                = "${var.name}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = true

  tags = {
    Environment = var.environment
  }
}