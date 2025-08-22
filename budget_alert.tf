# Variable for the resource group name
variable "resource_group_name" {
  description = "The name of the resource group containing the VMSS."
  type        = string
  default     = "rg-vmss-budget-demo"
}
 
# Variable for the VMSS name
variable "vmss_name" {
  description = "The name of the VMSS to monitor."
  type        = string
  default     = "vmss-budget-demo"
}
 
# Budget alert configuration
resource "azurerm_consumption_budget_subscription" "vmss_budget" {
  name            = "vmss-cost-budget"
  amount          = 50  # Set your desired budget amount in USD
  time_grain      = "Daily"
  time_period_start = "2025-08-01T00:00:00Z"
 
  # Filter to specifically monitor costs for the VMSS
  filter {
    resource_group {
      name = var.resource_group_name
    }
 
    resource {
      name = var.vmss_name
    }
  }
 
  # Action group to receive the alert
  notification {
    enabled = true
    operator = "GreaterThan"
    threshold = 90  # Alert when 90% of the budget is consumed
    threshold_type = "Actual"
    contact_emails = ["milind.damse@gmail.com"]
  }
}
 
output "budget_id" {
  value = azurerm_consumption_budget_subscription.vmss_budget.id
  description = "The ID of the created budget alert."
}

