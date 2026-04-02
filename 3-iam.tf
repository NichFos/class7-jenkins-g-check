# Jenkins S3 IAM Policy to allow Jenkins user to access S3 bucket and put objects into it


resource "aws_iam_policy" "jenkins_s3_access_policy" {
  name        = "JenkinsS3AccessPolicy"
  description = "Policy to allow Jenkins user to access S3 bucket"
  policy      = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowS3Access",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.g_check_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.g_check_bucket.id}/*"
        ],
      },{
        "Sid" : "AllowGetandPutBucketPolicy",
        "Effect" : "Allow",
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

resource "aws_iam_user_policy_attachment" "jenkins_s3_access_attachment" {
  user       = data.aws_iam_user.jenkins_user.user_name
  policy_arn = aws_iam_policy.jenkins_s3_access_policy.arn
}