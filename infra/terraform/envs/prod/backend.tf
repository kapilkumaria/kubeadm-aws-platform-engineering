terraform {
  backend "s3" {
    bucket         = "kapil-s3-bucket-for-kubeadm-cluster"   # same S3 bucket as dev
    key            = "kubeadm/prod/terraform.tfstate"        # different state file for prod env
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"                        # same DynamoDB table
    encrypt        = true
  }
}
