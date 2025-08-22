terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}


provider "azurerm" {
  features {}
  client_id = "4f703a45-8f95-4190-a2df-3107ec0059e1"
  client_secret = "SxQ8Q~hhJhPetxca.XoAjL0Sj6TEZPlbHVDEna0F"
  tenant_id = "5e865d62-8ae0-4163-9923-646bf3b4ffa1"
  subscription_id = "a01bd4dc-3157-43b6-a8f9-a9a3c40a0e8c" # Optional if using Azure CLI logn
}



data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "milindRg3"
  location = "eastus"
}

resource "azurerm_monitor_action_group" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "example"
}

resource "azurerm_consumption_budget_subscription" "example" {
  name            = "example"
  subscription_id = data.azurerm_subscription.current.id

  amount     = 1000
  time_grain = "Monthly"

  time_period {
    start_date = "2025-08-01T00:00:00Z"
    end_date   = "2025-09-01T00:00:00Z"
  }

  filter {
    dimension {
      name = "ResourceGroupName"
      values = [
        azurerm_resource_group.example.name,
      ]
    }

    tag {
      name = "foo"
      values = [
        "bar",
        "baz",
      ]
    }
  }

  notification {
    enabled   = true
    threshold = 90.0
    operator  = "EqualTo"

    contact_emails = [
      "milind.damse@gmail.com"
     
    ]

    contact_groups = [
      azurerm_monitor_action_group.example.id,
    ]

    contact_roles = [
      "Owner",
    ]
  }

  notification {
    enabled        = false
    threshold      = 100.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"

    contact_emails = [
      "milind.damse@gmail.com"
    ]
  }
}
