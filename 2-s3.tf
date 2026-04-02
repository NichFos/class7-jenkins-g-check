resource "aws_s3_bucket" "g_check_bucket" {
  bucket = "class7-jenkins-g-check-bucket" # Name of the S3 bucket
  tags = {
    Name        = "Jenkins G Check Bucket"
    Environment = "Cloud Row"
  }
}


resource "aws_s3_bucket_public_access_block" "g_check_bucket_pab" {
  bucket                  = aws_s3_bucket.g_check_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "g_check_bucket_policy" {
  bucket = aws_s3_bucket.g_check_bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.g_check_bucket.id}/*"
        ]
      },
      {
        "Sid" : "AllowGetandPutBucketPolicy",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.g_check_bucket.id}"
        ]
      }
    ]
  })
}


resource "aws_s3_bucket_ownership_controls" "g_check_bucket_owner" {

  bucket = aws_s3_bucket.g_check_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_object" "repo_txt01" {
  bucket       = aws_s3_bucket.g_check_bucket.id
  key          = "armageddon-repo.txt"
  source       = "armageddon-repo.txt"
  acl          = "private"
  content_type = "text/plain; charset=utf-8"
  etag         = filemd5("armageddon-repo.txt")
}

#