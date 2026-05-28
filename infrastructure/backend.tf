terraform {
  backend "s3" {
    bucket         = "tatiana-ironhack-tf-state-2026"
    key            = "project/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tatiana-terraform-locks"
    encrypt        = true
  }
}