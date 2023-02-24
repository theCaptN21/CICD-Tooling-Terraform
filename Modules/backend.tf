# --- backend.tf ---

terraform {
  backend "s3" {
    bucket = "gitlabbucket00234"
    key    = "terraformstate"
    region = "us-east-1"
  }
}

