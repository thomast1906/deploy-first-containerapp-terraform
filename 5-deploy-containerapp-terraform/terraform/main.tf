data "azurerm_resource_group" "rg" {
  name = "${var.app_name}-rg"
}

data "azurerm_log_analytics_workspace" "la" {
  name                = "${var.app_name}la"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_container_registry" "acr" {
  name                = "${var.app_name}acracr"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azapi_resource" "containerapp_environment" {
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  name      = "${var.app_name}acaenv"
  parent_id = data.azurerm_resource_group.rg.id
  location  = data.azurerm_resource_group.rg.location

  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = data.azurerm_log_analytics_workspace.la.workspace_id
          sharedKey  = data.azurerm_log_analytics_workspace.la.primary_shared_key
        }
      }
    }
  })
}

resource "azurerm_user_assigned_identity" "containerapp" {
  location            = data.azurerm_resource_group.rg.location
  name                = "containerappmi"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "containerapp" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_user_assigned_identity.containerapp.principal_id
  depends_on = [
    azurerm_user_assigned_identity.containerapp
  ]
}

resource "azapi_resource" "containerappmi" {
  type      = "Microsoft.App/containerapps@2022-03-01"
  name      = "${var.app_name}containermi"
  parent_id = data.azurerm_resource_group.rg.id
  location  = data.azurerm_resource_group.rg.location


  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.containerapp.id]
  }
  body = jsonencode({

    properties = {
      managedEnvironmentId = azapi_resource.containerapp_environment.id
      configuration = {
        ingress = {
          external : true,
          targetPort : 80
        },
        "registries" : [
          {
            "server" : data.azurerm_container_registry.acr.login_server,
            "identity" : azurerm_user_assigned_identity.containerapp.id
          }
        ]
      }
      template = {
        containers = [
          {
            image = "${data.azurerm_container_registry.acr.login_server}/aspcoresample:${var.GITHUB_SHA}",
            name  = "firstcontainerappacracr"
            resources = {
              cpu    = 0.25
              memory = "0.5Gi"
            },
            "probes" : [
              {
                "type" : "Liveness",
                "httpGet" : {
                  "path" : "/",
                  "port" : 80,
                  "scheme" : "HTTP"
                },
                "periodSeconds" : 10
              },
              {
                "type" : "Readiness",
                "httpGet" : {
                  "path" : "/",
                  "port" : 80,
                  "scheme" : "HTTP"
                },
                "periodSeconds" : 10
              },
              {
                "type" : "Startup",
                "httpGet" : {
                  "path" : "/",
                  "port" : 80,
                  "scheme" : "HTTP"
                },
                "periodSeconds" : 10
              }
            ]
          }
        ]
        scale = {
          minReplicas = 0,
          maxReplicas = 2
        }
      }
    }

  })
  ignore_missing_property = true
  depends_on = [
    azapi_resource.containerapp_environment
  ]
}
