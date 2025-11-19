# Description: Hub Services Module
# This module contains shared infrastructure services for the hub VNet:
# - Azure Bastion (secure VM access)
# - NAT Gateway (shared internet egress)
# - Application Gateway (ingress with WAF)

# ------------------------------------------------------------------------------
# AZURE BASTION
# ------------------------------------------------------------------------------

resource "azurerm_public_ip" "bastion_pip" {
  name                = "${var.hub_vnet_name}-bastion-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_bastion_host" "bastion" {
  name                = "${var.hub_vnet_name}-bastion"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# NAT GATEWAY
# ------------------------------------------------------------------------------

resource "azurerm_public_ip" "nat_gateway_pip" {
  name                = "${var.hub_vnet_name}-nat-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = "${var.hub_vnet_name}-nat-gtw"
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

  tags = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_pip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_associations" {
  for_each = var.nat_gateway_subnets

  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
# ------------------------------------------------------------------------------
# APPLICATION GATEWAY
# ------------------------------------------------------------------------------

resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.hub_vnet_name}-appgw-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_application_gateway" "appgw" {
  name                = "${var.hub_vnet_name}-appgw"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "appgw-ip-configuration"
    subnet_id = var.appgw_subnet_id
  }

  frontend_port {
    name = "http-frontend-port"
    port = 80
  }

  # frontend_port {
  #   name = "https-frontend-port"
  #   port = 443
  # }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "vm-backend-pool"
  }

  backend_http_settings {
    name                                = "http-backend-settings"
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 60
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "http-frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "http-routing-rule"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "vm-backend-pool"
    backend_http_settings_name = "http-backend-settings"
  }

  probe {
    name                                      = "http-health-probe"
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  tags = var.tags
}
