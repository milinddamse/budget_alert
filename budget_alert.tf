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
