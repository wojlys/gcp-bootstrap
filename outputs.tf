output "infra_billing_accounts" {
  value       = var.billing_accounts
  description = "Billing accounts for Infra projects"
}

output "organization_id" {
  value       = var.organization_id
  description = "Numeric ID of the organization"
}

output "parent_id" {
  value       = var.parent_folder_id
  description = "ID of the folder where Infra projects are kept"
}


