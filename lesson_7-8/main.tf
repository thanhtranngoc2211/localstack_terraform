locals {
    principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]
    tags = {
        project = var.project
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_resourcegroups_group" "resourcegroups_group" {
    name = "${var.project}-s3-backend"

    resource_query {
      query = <<-JSON
        {
            "ResourceTypeFilters": [
                "AWS::AllSupported"
            ],
            "TagFilters": [
                {
                    "Key": "project",
                    "Values": ["${var.project}"]
                }
            ]
        }
        JSON
    }
}

output "config" {
    value = {
        bucket = aws_s3_bucket.s3_bucket.bucket
        role_arn = aws_iam_role.iam_role.arn
        dynamodb_table = aws_dynamodb_table.dynamodb_table.name
    }
}