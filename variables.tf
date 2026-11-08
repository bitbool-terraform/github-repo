variable "repo_name" {
  type        = string
}

variable "create_repository" {
  type        = bool
  default     = false
}

variable "actions_variables" {
  default = {}
}

variable "actions_secrets" {
  default = {}
}

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

variable "default_branch" {
  type        = string
  default     = "main"
}

variable "enable_ci" {
  type        = bool
  default     = true
}

variable "workflow_name_prefix" {
  type        = string
  default     = "deploy-"
}

variable "commit_author" {
  type        = string
  default     = "pseudorandomized"
}

variable "commit_email" {
  type        = string
  default     = "pseudorandomized@gmail.com"
}

variable "skip_ci_on_commit" {
  type        = bool
  default     = true
}

variable "commit_message" {
  type        = string
  default     = null
}

variable "additional_files" {
  type = map(object({
    content        = string
    commit_message = optional(string)
  }))

  default = {}
}

variable "deploy_branches" {
  type    = list(string)
  default = []
}

variable "docker_build_deploy_ref" {
  type    = string
  default = "v2"
}