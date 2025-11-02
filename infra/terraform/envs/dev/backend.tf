terraform {
  backend "s3" {
    bucket         = "kapil-s3-bucket-for-kubeadm-cluster"   # existing S3 bucket
    key            = "kubeadm/dev/terraform.tfstate"         # file path inside the bucket
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"                        # existing DynamoDB table name
    encrypt        = true
  }
}
