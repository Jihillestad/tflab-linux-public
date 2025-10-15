# Description: This file contains the configuration for Azure Application Gateway.
# Application Gateway provides secure HTTP/HTTPS ingress with Web Application Firewall (WAF)
# capabilities, routing traffic to private backend VMs without exposing them directly.




# Public IP for Application Gateway

resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.prefix}-${var.project_name}-appgw-pip-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}


# Application Gateway

resource "azurerm_application_gateway" "appgw" {
  name                = "${var.prefix}-${var.project_name}-appgw-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "appgw-ip-configuration"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_port {
    name = "http-frontend-port"
    port = 80
  }

  frontend_port {
    name = "https-frontend-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "vm-backend-pool"
  }

  backend_http_settings {
    name                  = "http-backend-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "http-health-probe"
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
    name                = "http-health-probe"
    protocol            = "Http"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    host                = "127.0.0.1"
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  tags = var.tags
}
