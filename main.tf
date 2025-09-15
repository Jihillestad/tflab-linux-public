resource "azurerm_resource_group" "tflab_linux" {
  name     = "${var.prefix}-${var.project_name}-rg-${var.environment}"
  location = var.location
}
