# --- autoscaling/backend.tf ---

terraform {
  backend "s3" {
    bucket = "cicd-final-bucket"
    key    = "terraform-cicd-codepipeline/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "state-bucket" {
    bucket = "cicd-final-bucket"
    lifecycle {
      prevent_destroy = true
    }
    versioning {
      enabled = true
    }
    server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
      }
    }
}