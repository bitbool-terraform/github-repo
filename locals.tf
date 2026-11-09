locals {
  repository_name = var.create_repository ? github_repository.this[0].name : var.repo_name

  workflow_filename = ".github/workflows/deploy.yml"

  skip_ci = var.skip_ci_on_commit ? "[skip ci]" : ""
  commit_message = "[DevOps]${local.skip_ci} Updated CI/CD pipelines"

  selected_profile = local.profiles[var.deploy_profile][var.build_profile]

  workflow_template = lookup(local.selected_profile,"workflow",local.profiles[var.deploy_profile]["generic"].workflow)

  ci_file = {
    "${local.workflow_filename}" = {
      content = templatefile("${path.module}/templates/${local.selected_profile.workflow}", {
        deploy_branches         = var.deploy_branches
        docker_build_deploy_ref = var.docker_build_deploy_ref
    })

      # commit_message = 
    }
  }

  env_file = {}

  # repository_files = merge(local.ci_file,local.env_file)

  target_branches = sort(distinct(concat([var.default_branch],var.deploy_branches)))

  ci_file_enabled = var.enable_ci ? local.ci_file : {}
  file_templates = merge(local.ci_file_enabled,var.additional_files)

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