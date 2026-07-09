# ==============================================================================
# STEP 1 - CREATE S3 BUCKETS
# ==============================================================================

# 1A - Create Website Bucket
resource "aws_s3_bucket" "website" {
  bucket = "project5-website-${var.bucket_suffix}"
}
resource "aws_s3_bucket_ownership_controls" "website_acl" {
  bucket = aws_s3_bucket.website.id
  rule { object_ownership = "BucketOwnerPreferred" }
}
resource "aws_s3_bucket_public_access_block" "website_bpa" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_versioning" "website_versioning" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "website_encryption" {
  bucket = aws_s3_bucket.website.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

# 1B - Create Data Bucket
resource "aws_s3_bucket" "data" {
  bucket = "project5-data-${var.bucket_suffix}"
}
resource "aws_s3_bucket_ownership_controls" "data_acl" {
  bucket = aws_s3_bucket.data.id
  rule { object_ownership = "BucketOwnerEnforced" }
}
resource "aws_s3_bucket_public_access_block" "data_bpa" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "data_versioning" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "data_encryption" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

# 1C - Create Replication Destination Bucket (Singapore)
resource "aws_s3_bucket" "replication" {
  provider = aws.singapore
  bucket   = "project5-replication-${var.bucket_suffix}"
}
resource "aws_s3_bucket_ownership_controls" "replication_acl" {
  provider = aws.singapore
  bucket   = aws_s3_bucket.replication.id
  rule { object_ownership = "BucketOwnerEnforced" }
}
resource "aws_s3_bucket_public_access_block" "replication_bpa" {
  provider                = aws.singapore
  bucket                  = aws_s3_bucket.replication.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "replication_versioning" {
  provider = aws.singapore
  bucket   = aws_s3_bucket.replication.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "replication_encryption" {
  provider = aws.singapore
  bucket   = aws_s3_bucket.replication.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

# Forge the padlock key (KMS Key)
resource "aws_kms_key" "s3_key" {
  description             = "Project 5 S3 encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}
resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/project5-s3-key"
  target_key_id = aws_kms_key.s3_key.key_id
}

# 1D - Create Encrypted Bucket
resource "aws_s3_bucket" "encrypted" {
  bucket = "project5-encrypted-${var.bucket_suffix}"
}
resource "aws_s3_bucket_ownership_controls" "encrypted_acl" {
  bucket = aws_s3_bucket.encrypted.id
  rule { object_ownership = "BucketOwnerEnforced" }
}
resource "aws_s3_bucket_public_access_block" "encrypted_bpa" {
  bucket                  = aws_s3_bucket.encrypted.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "encrypted_versioning" {
  bucket = aws_s3_bucket.encrypted.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypted_encryption" {
  bucket = aws_s3_bucket.encrypted.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# 1E - Create Compliance Bucket (Object Lock)
resource "aws_s3_bucket" "compliance" {
  bucket              = "project5-compliance-${var.bucket_suffix}"
  object_lock_enabled = true
}
resource "aws_s3_bucket_ownership_controls" "compliance_acl" {
  bucket = aws_s3_bucket.compliance.id
  rule { object_ownership = "BucketOwnerEnforced" }
}
resource "aws_s3_bucket_public_access_block" "compliance_bpa" {
  bucket                  = aws_s3_bucket.compliance.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "compliance_versioning" {
  bucket = aws_s3_bucket.compliance.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "compliance_encryption" {
  bucket = aws_s3_bucket.compliance.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

# 1F - Create Logs Bucket
resource "aws_s3_bucket" "logs" {
  bucket = "project5-logs-${var.bucket_suffix}"
}
resource "aws_s3_bucket_ownership_controls" "logs_acl" {
  bucket = aws_s3_bucket.logs.id
  rule { object_ownership = "BucketOwnerEnforced" }
}
resource "aws_s3_bucket_public_access_block" "logs_bpa" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_server_side_encryption_configuration" "logs_encryption" {
  bucket = aws_s3_bucket.logs.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

# 1G - Enable Server Access Logging on Data Bucket
resource "aws_s3_bucket_logging" "data_logging" {
  bucket        = aws_s3_bucket.data.id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "data-bucket-logs/"
}

# ==============================================================================
# STEP 2 - STATIC WEBSITE HOSTING WITH CLOUDFRONT
# ==============================================================================

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id
  index_document { suffix = "index.html" }
  error_document { key = "error.html" }
}

resource "aws_s3_bucket_policy" "website_public_read" {
  depends_on = [
    aws_s3_bucket_public_access_block.website_bpa,
    aws_s3_bucket_ownership_controls.website_acl
  ]
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "website_cdn" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.website_config.website_endpoint
    origin_id   = "S3-Website-${aws_s3_bucket.website.id}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Project 5 S3 website distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Website-${aws_s3_bucket.website.id}"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }
  price_class = "PriceClass_100"
  restrictions {
    geo_restriction { restriction_type = "none" }
  }
  viewer_certificate { cloudfront_default_certificate = true }
}

# ==============================================================================
# STEP 3 - BUCKET POLICIES AND ACCESS CONTROL
# ==============================================================================

resource "aws_s3_bucket_policy" "data_security_policy" {
  bucket = aws_s3_bucket.data.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceHTTPSOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.data.arn,
          "${aws_s3_bucket.data.arn}/*"
        ]
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      }
    ]
  })
}

# ==============================================================================
# STEP 4 - LIFECYCLE MANAGEMENT (The Robot Maid)
# ==============================================================================

resource "aws_s3_bucket_lifecycle_configuration" "data_lifecycle" {
  bucket = aws_s3_bucket.data.id

  rule {
    id     = "project5-data-lifecycle"
    status = "Enabled"

    # THE FIX: Hand the robot the "All Toys" note!
    filter {}

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 90
      storage_class = "GLACIER_IR"
    }
    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
    expiration {
      days = 365
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  rule {
    id     = "project5-versions-cleanup"
    status = "Enabled"

    # THE FIX: Hand the robot the "All Toys" note!
    filter {}

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }
    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }
    noncurrent_version_expiration {
      noncurrent_days           = 90
      newer_noncurrent_versions = 3
    }
  }
}

# ==============================================================================
# STEP 5 - CROSS-REGION REPLICATION (The Magical Teleporter)
# ==============================================================================

resource "aws_iam_role" "replication_role" {
  name = "project5-s3-replication-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "s3.amazonaws.com" } }]
  })
}

resource "aws_iam_policy" "replication_policy" {
  name = "project5-replication-inline-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Effect = "Allow", Action = ["s3:GetReplicationConfiguration", "s3:ListBucket"], Resource = aws_s3_bucket.data.arn },
      { Effect = "Allow", Action = ["s3:GetObjectVersionForReplication", "s3:GetObjectVersionAcl", "s3:GetObjectVersionTagging"], Resource = "${aws_s3_bucket.data.arn}/*" },
      { Effect = "Allow", Action = ["s3:ReplicateObject", "s3:ReplicateDelete", "s3:ReplicateTags"], Resource = "${aws_s3_bucket.replication.arn}/*" }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}

resource "aws_s3_bucket_replication_configuration" "crr" {
  depends_on = [aws_s3_bucket_versioning.data_versioning]
  bucket = aws_s3_bucket.data.id
  role   = aws_iam_role.replication_role.arn

  rule {
    id     = "project5-crr-rule"
    status = "Enabled"

    # THE FIX: Tell the teleporter to grab "All Toys"
    filter {}

    destination {
      bucket        = aws_s3_bucket.replication.arn
      storage_class = "STANDARD"
      
      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }
      
      metrics {
        status = "Enabled"
        event_threshold {
          minutes = 15
        }
      }
    }
    delete_marker_replication { status = "Enabled" }
  }
}

# ==============================================================================
# STEP 6 - S3 EVENT NOTIFICATIONS (The Magic Bell & Robot Helper)
# ==============================================================================

# 6B - The Ledger Book (DynamoDB Table to track files)
resource "aws_dynamodb_table" "tracking" {
  name         = "project5-file-tracking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "file_key"
  range_key    = "event_timestamp"

  attribute {
    name = "file_key"
    type = "S"
  }
  attribute {
    name = "event_timestamp"
    type = "S"
  }
}

# 6C - The Alert System (SNS Topic - The Walkie Talkie)
resource "aws_sns_topic" "alerts" {
  name = "project5-s3-notifications"
}

# Subscribe your email to the alerts (Make sure this is your real email!)
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "dileep81.b@gmail.com" 
}

# 6D - The Robot's ID Badge (IAM Role for Lambda)
resource "aws_iam_role" "lambda_role" {
  name = "project5-s3-processor-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Give the Robot permission to read S3, write to DynamoDB, and send SNS
resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "lambda_ddb" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
resource "aws_iam_role_policy_attachment" "lambda_sns" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 6A & 6E - Build the Robot's Brain (Zip the Python Code and Deploy Lambda)
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/s3-processor.zip"
  
  source {
    filename = "lambda_function.py"
    # THIS is the Python code! Terraform creates the file for us automatically.
    content  = <<-EOF
import boto3
import json
import os
import logging
from datetime import datetime
from urllib.parse import unquote_plus

logger = logging.getLogger()
logger.setLevel(logging.INFO)
s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN', '')
TRACKING_TABLE = os.environ.get('TRACKING_TABLE', '')

def lambda_handler(event, context):
    logger.info(f"Received event: {json.dumps(event)}")
    for record in event.get('Records', []):
        event_name = record.get('eventName', '')
        bucket = record['s3']['bucket']['name']
        key = unquote_plus(record['s3']['object']['key'])
        size = record['s3']['object'].get('size', 0)
        timestamp = datetime.utcnow().isoformat()
        
        if TRACKING_TABLE:
            table = dynamodb.Table(TRACKING_TABLE)
            table.put_item(Item={
                'file_key': key,
                'event_timestamp': timestamp,
                'event_name': event_name,
                'bucket_name': bucket,
                'file_size': size
            })
    return {'statusCode': 200, 'body': 'Processed Successfully'}
EOF
  }
}

resource "aws_lambda_function" "processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "project5-s3-processor"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  timeout          = 30
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN  = aws_sns_topic.alerts.arn
      TRACKING_TABLE = aws_dynamodb_table.tracking.name
    }
  }
}

# 6F - Allow the Mailbox to ring the Bell (S3 permission to invoke Lambda)
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data.arn
}

# 6G - Attach the Bell to the Mailbox (S3 Event Notification)
resource "aws_s3_bucket_notification" "bucket_notification" {
  depends_on = [aws_lambda_permission.allow_s3]
  bucket     = aws_s3_bucket.data.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
  }
} 

# ==============================================================================
# STEP 9 - S3 BATCH OPERATIONS (The Robot Army)
# ==============================================================================

# 9A - The Robot Army's ID Badge (IAM Role for S3 Batch Operations)
resource "aws_iam_role" "batch_ops_role" {
  name = "project5-batch-ops-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "batchoperations.s3.amazonaws.com"
        }
      }
    ]
  })
}

# 9B - Give the Robot Army permission to touch all the toys (S3 Full Access)
resource "aws_iam_role_policy_attachment" "batch_ops_s3_access" {
  role       = aws_iam_role.batch_ops_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}