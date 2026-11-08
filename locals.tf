locals {
  repository_name = var.create_repository ? github_repository.this[0].name : var.name

  workflow_filename = ".github/workflows/deploy.yml"
  env_filename = ".github/envs/${var.deploy_env}"

  skip_ci = var.skip_ci ? "[skip ci]" : ""
  commit_message = "[DevOps]${local.skip_ci} Updated CI/CD pipelines"

  ci_file = {
    "${local.workflow_filename}" = {
      content = templatefile("${path.module}/templates/aca-deploy.yml.tftpl", {
        deploy_branches         = var.deploy_branches
        docker_build_deploy_ref = var.docker_build_deploy_ref
    })

      # commit_message = 
    }
  }

  env_file = {
    "${local.env_filename}" = {
      content = templatefile("${path.module}/templates/env.tftpl", {
        container_app_name = var.container_app_name
        resource_group = var.resource_group

      })
      # commit_message = 
    }
  }

  # repository_files = merge(local.ci_file,local.env_file)

  target_branches = sort(distinct(concat([var.default_branch],var.deploy_branches)))
  file_templates = merge(local.ci_file,var.additional_files)

  repository_files = {
    for pair in setproduct(local.target_branches, keys(local.file_templates)) :
    "${pair[0]}::${pair[1]}" => merge(
      local.file_templates[pair[1]],
      {
        branch = pair[0]
        file   = pair[1]
      }
    )
  }
}