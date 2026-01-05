provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "site" {
  bucket = "devops-lab-site-12345"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.site.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.site.arn}/*"
    }]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.site.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}
