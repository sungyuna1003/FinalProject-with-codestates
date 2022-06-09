resource "aws_kinesis_stream" "terraform-data_stream" {
  name             = "terraform-datastream"
  shard_count      = 1
  retention_period = 24
}

resource "aws_kinesis_stream_consumer" "kinesis_consumer" {
  name       = "terraform-delivery-stream"
  stream_arn = aws_kinesis_stream.terraform-data_stream.arn
  
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "firehose_policy" {
    policy = data.aws_iam_policy_document.firehose_policy.json
}

resource "aws_iam_role_policy_attachment" "firehose_policy" {
  role       = "${aws_iam_role.firehose_role.name}"
  policy_arn = "${aws_iam_policy.firehose_policy.arn}"
}

data "aws_iam_policy_document" "firehose_policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::olatte2-s3-bucket",
                "arn:aws:s3:::olatte2-s3-bucket/*"]

    actions = [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject",
    ]
  }

  statement {
    sid       = "AllowKinesisFullAccess"
    effect    = "Allow"
    resources = ["*"]

    actions = ["kinesis:*"]
  }

  statement {
    sid       = "lambdaInvoke"
    effect    = "Allow"
    resources = ["*"]

    actions = [
                "lambda:InvokeFunction",
                "lambda:GetFunctionConfiguration"
    ]
  }

  statement {
    sid =      ""
    effect =   "Allow"
    actions =  [
               "es:DescribeElasticsearchDomain",
               "es:DescribeElasticsearchDomains",
                "es:DescribeElasticsearchDomainConfig",
                "es:ESHttpPost",
                "es:ESHttpPut"]
    resources = ["*"]
  }

  statement {
    sid      = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["es:ESHttpGet"]
  }

statement {
  sid       = "Stmt1480452973134"
  actions    = ["*"]
  effect    = "Allow"
  resources  = ["*"]
  }

  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kinesis:DescribeStream",
                "kinesis:GetShardIterator",
                "kinesis:GetRecords",
                "kinesis:ListShards"]
  }
  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:ap-northeast-2:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  name        = "terraform-delivery-stream"
  destination = "elasticsearch"
  s3_configuration {
    role_arn           = "${aws_iam_role.firehose_role.arn}"
    bucket_arn         = "arn:aws:s3:::olatte2-s3-bucket"
  }
  elasticsearch_configuration {
    domain_arn = "arn:aws:es:ap-northeast-2:${var.amazon_id}:domain/terraform-domain"
    role_arn   = "${aws_iam_role.firehose_role.arn}"
    index_name = "location-index"
  }
  kinesis_source_configuration {
    kinesis_stream_arn = "arn:aws:kinesis:ap-northeast-2:${var.amazon_id}:stream/terraform-datastream"
    role_arn = "${aws_iam_role.firehose_role.arn}"
  }
  depends_on = [
    #opensearch_example
    aws_elasticsearch_domain.aos
  ]
}
resource "aws_s3_bucket" "streamb" {
  bucket = "streamb"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.streamb.id
  acl    = "private"
}
