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
  for_each = var.actions_secrets

  repository      = local.repository_name
  secret_name     = each.key
  plaintext_value = local.actions_secrets[each.key]

  depends_on = [github_repository.this]
}

resource "github_actions_variable" "this" {
  for_each = var.actions_variables

  repository    = local.repository_name
  variable_name = each.key
  value         = each.value

  depends_on = [github_repository.this]
}

resource "github_repository_file" "this" {
  for_each = local.repository_files

  repository          = local.repository_name
  branch              = each.value.branch
  file                = each.value.file
  content             = each.value.content
  commit_message      = coalesce(var.commit_message ,try(each.value.commit_message, null), local.commit_message)
  commit_author       = var.commit_author
  commit_email        = var.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.this]
}