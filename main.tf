# Create s3 bucket

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Confifure static website hosting

resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }

}

# Set bucket policy

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.s3_bucket.arn,
          "${aws_s3_bucket.s3_bucket.arn}/*",
        ]
      },
    ]
  })
}

# Upload html files

resource "aws_s3_object" "object_www" {
  depends_on   = [aws_s3_bucket.s3_bucket]
  for_each     = fileset("./assets/", "*.html")
  bucket       = var.bucket_name
  key          = basename(each.value)
  source       = "./assets/${each.value}"
  etag         = filemd5("./assets/${each.value}")
  content_type = "text/html"
  acl          = "public-read"
}

# Upload CSS

resource "aws_s3_object" "object_css" {
  depends_on   = [aws_s3_bucket.s3_bucket]
  for_each     = fileset("./assets/", "*.css")
  bucket       = var.bucket_name
  key          = basename(each.value)
  source       = "./assets/${each.value}"
  etag         = filemd5("./assets/${each.value}")
  content_type = "text/css"
  acl          = "public-read"
}


# resource "aws_s3_bucket" "s3_host_website" {
#     bucket = "portfolio-static-website"

#     tags = {
#         Name = "My Bucket"
#         Environment = "Dev"
#     }
# }

# resource "aws_s3_bucket_policy" "s3_host_website" {
#   bucket = aws_s3_bucket.s3_host_website.id

#   policy = jsonencode({
#   Version = "2012-10-17"
#   Statement = [
#     {
#     Sid       = "PublicReadGetObject"
#     Effect    = "Allow"
#     Principal = "*"
#     Action    = "s3:GetObject"
#     Resource = [
#       aws_s3_bucket.s3_host_website.arn,
#       "${aws_s3_bucket.s3_host_website.arn}/*",
#     ]
#     },
#   ]
#   })

#   depends_on = [
#   aws_s3_bucket_public_access_block.s3_host_website
#   ]
# }

# resource "aws_s3_bucket_website_configuration" "s3_host_website" {
#     bucket = aws_s3_bucket.s3_host_website.id

#     index_document {
#       suffix = "index.html"
#     }

#     error_document {
#       key = "404.html"
#     }
# }

# resource "aws_s3_bucket_public_access_block" "s3_host_website" {
#   bucket = aws_s3_bucket.s3_host_website.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_ownership_controls" "s3_host_website" {
#   bucket = aws_s3_bucket.s3_host_website.id
#   rule {
#   object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "s3_host_website" {
#   bucket = aws_s3_bucket.s3_host_website.id

#   acl = "public-read"
#   depends_on = [
#   aws_s3_bucket_ownership_controls.s3_host_website,
#   aws_s3_bucket_public_access_block.s3_host_website
#   ]
# }

# resource "aws_s3_object" "object" {
#   for_each = fileset("./assets/", "*")
#   bucket = aws_s3_bucket.s3_host_website.id
#   key = each.value
#   source = "./assets/${each.value}"
# }