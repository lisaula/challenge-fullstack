locals {
  env = terraform.workspace
}

resource "aws_s3_bucket" "example" {
  for_each = var.bucket
  bucket = each.key

  tags = {
    Name        = each.key
    Environment = local.env
  }
}

resource "aws_s3_bucket_website_configuration" "example" {
  for_each = var.bucket
  
  bucket = aws_s3_bucket.example[each.key].id

  index_document {
    suffix = each.value.index_document
  }

  error_document {
    key = each.value.error_document
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  for_each = var.bucket
  bucket = aws_s3_bucket.example[each.key].id

  block_public_acls       = each.value.block_public_access
  block_public_policy     = each.value.block_public_access
  ignore_public_acls      = each.value.block_public_access
  restrict_public_buckets = each.value.block_public_access
}


resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
    for_each = var.bucket
    bucket = aws_s3_bucket.example[each.key].id
    policy = data.aws_iam_policy_document.allow_access_from_another_account[each.key].json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  for_each = var.bucket
  
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.example[each.key].arn,
      "${aws_s3_bucket.example[each.key].arn}/*",
    ]
  }
}