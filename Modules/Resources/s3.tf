# --- s3.tf ---

resource "aws_s3_bucket" "tfstate" {
  bucket = "gitlabbucket00234"

  lifecycle {
    prevent_destroy = true
  }
}
