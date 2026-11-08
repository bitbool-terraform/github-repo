resource "github_repository" "this" {
  count = var.create_repository ? 1 : 0

  name        = var.name
  description = var.description
  visibility  = var.visibility

  has_issues      = true
  has_projects    = false
  has_wiki        = false
  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
}

resource "github_actions_secret" "this" {
  for_each = local.actions_secrets

  repository      = local.repository_name
  secret_name     = each.key
  plaintext_value = local.actions_secrets[each.key]

  depends_on = [
    github_repository.this
  ]
}

resource "github_actions_variable" "this" {
  for_each = local.actions_variables

  repository    = local.repository_name
  variable_name = each.key
  value         = each.value

  depends_on = [
    github_repository.this
  ]
}

resource "github_repository_file" "this" {
  for_each = local.repository_files

  repository          = local.repository_name
  branch              = var.default_branch
  file                = each.key
  content             = each.value.content
  commit_message      = coalesce(each.value.commit_message, "Manage ${each.key} via Terraform")
  commit_author       = var.commit_author
  commit_email        = var.commit_email
  overwrite_on_create = true

  depends_on = [
    github_repository.this
  ]
}