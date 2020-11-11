provider "aws" {
region = "us-east-1"
}



terraform {
  backend "s3" {
    bucket = "solvejobs-tfstates"
    key    = "staging"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "test" {
  bucket = "bucket-solve-jobs"
  acl    = "private"

  tags = {
    Name        = "bucket-solve-jobs"
    Environment = "Dev"
  }
}
