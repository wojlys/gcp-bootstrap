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

variable "billing_accounts" {
  type = object({
    network = string
    compute = string
  })
  description = "Billing accounts to use for Infra projects"
}





/* API variables */
variable "network_project_apis" {
  type = set(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
  description = "Set of APIs required by the rss-network project"
}

variable "compute_project_apis" {
  type = set(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
  description = "Set of APIs required by the rss-compute project"
}




/* IAM variables */
variable "network_sa_roles" {
  type    = set(string)
  default = ["roles/compute.networkAdmin", "roles/compute.securityAdmin"]
}

variable "compute_sa_roles" {
  type    = set(string)
  default = ["roles/compute.instanceAdmin.v1"]

}
