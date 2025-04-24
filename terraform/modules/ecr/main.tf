resource "aws_ecr_repository" "this" {
  for_each = toset(var.repository_names)

  name                 = each.key
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key        = var.kms_key_arn
  }

  tags = merge(var.tags, { Name = each.key })
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = var.enable_lifecycle_policy ? aws_ecr_repository.this : {}

  repository = each.value.name
  policy     = jsonencode({
    rules = [
      for rule in var.lifecycle_rules : {
        rulePriority = rule.rulePriority
        description  = rule.description
        selection = {
          tagStatus   = rule.tagStatus
          tagPrefixes = rule.tagPrefixes
          countType   = rule.countType
          countNumber = rule.countNumber
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}