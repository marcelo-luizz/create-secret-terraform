terraform {
  backend "s3" {
    bucket = "bucket-test-gh"
    key = "p1.tfstate"
    region  = "us-east-1" // AWS region of state resources
  }
}
