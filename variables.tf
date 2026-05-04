/* Organization variables */

variable "organization_id" {
  type        = string
  default     = "272424585276"
  description = "ID of the organization"
}
variable "parent_folder_id" {
  type        = string
  default     = "529910092656"
  description = "Numeric ID of the GCP folder where TF should create projects"
}



/* Project variables */
variable "this_project" {
  type        = string
  default     = "rss-bootstrap-nyww"
  description = "Bootstrap project name"
}


variable "this_billing" {
  type = object({
    network = string
    compute = string
  })
  description = "Billing accounts to use for Infra projects"
}



