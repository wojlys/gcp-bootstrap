output "infra_billing_accounts" {
  value       = var.this_billing
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

