# Description: Azure Policy assignments for governance and compliance
# Policies are applied at the resource group level to enforce standards

# Policy 1: Allowed Locations
# Restricts resource creation to Norway East and Norway West regions
resource "azurerm_resource_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  resource_group_id    = azurerm_resource_group.tflab_linux.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["norwayeast", "norwaywest"]
    }
  })

  # Optional: Add metadata
  metadata = jsonencode({
    category = "General"
    version  = "1.0.0"
  })
}

# Policy 2: Require Environment Tag
# Ensures all resources have an Environment tag
resource "azurerm_resource_group_policy_assignment" "require_environment_tag" {
  name                 = "require-environment-tag"
  resource_group_id    = azurerm_resource_group.tflab_linux.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })

  metadata = jsonencode({
    category = "Tags"
    version  = "1.0.0"
  })
}
