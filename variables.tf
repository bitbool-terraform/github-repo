variable "repo_name" {
  type        = string
}

variable "systemenv" {}
variable "resource_group" {}

variable "description" {
  type        = string
  default     = null
}

variable "visibility" {
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "public", "internal"], var.visibility)
    error_message = "visibility must be one of: private, public, internal."
  }
}

variable "create_repository" {
  type        = bool
  default     = true
}

variable "default_branch" {
  type        = string
  default     = "main"
}

variable "deploy_branch" {
  type        = string
}

variable "deploy_env" {
  type        = string
}
variable "azure_client_id" {
  type        = string
}

variable "acr_name" {
  type        = string
}

variable "acr_registry" {
  type        = string
}

variable "acr_repo" {
  type        = string
}

variable "container_app_name" {
  type        = string
}

variable "workflow_filename" {
  type        = string
  default     = ".github/workflows/main-aca-ci.yml"
}

variable "commit_author" {
  type        = string
  default     = "pseudorandomized"
}

variable "commit_email" {
  type        = string
  default     = "antonis@bitbool.net"
}

variable "commit_message" {
  type        = string
  default     = "[DevOps] Update CI workflow"
}