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
# encryption_configuration {
#   encryption_type = var.encryption_type
#   kms_key_id      = var.kms_key_arn  # Corrected from kms_key -> kms_key_id
# }

  tags = merge(var.tags, { Name = each.key })
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each  = aws_ecr_repository.this
  repository = each.value.name  # Correct reference
  policy     = jsonencode({
    rules = [{
      rulePriority = 1,
      description  = "Expire old tagged images"
      selection = {
        tagStatus     = "tagged"
        tagPrefixList = ["v"]
        countType     = "imageCountMoreThan"
        countNumber   = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}
