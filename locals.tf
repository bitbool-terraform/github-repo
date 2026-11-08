locals {
  repository_name = var.create_repository ? github_repository.this[0].name : var.name

  workflow_filename = ".github/workflows/main-aca-${var.systemenv}"
  env_filename = ".github/envs/${var.deploy_env}"

  ci_file = {
    "${local.workflow_filename}" = {
      content = templatefile("${path.module}/templates/main-aca.yml.tftpl", {

        deploy_branch = var.deploy_branch
        azure_acr_name = var.acr_name
        azure_acr_registry = var.acr_registry
        azure_acr_repo = var.acr_repo
      })
      commit_message = var.commit_message
    }
  }

  env_file = {
    "${local.env_filename}" = {
      content = templatefile("${path.module}/templates/env.tftpl", {
        container_app_name = var.container_app_name
        resource_group = var.resource_group

      })
      commit_message = var.commit_message
    }
  }

  repository_files = merge(local.ci_file,local.env_file)
}