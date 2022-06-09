resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.role_for_LDC.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
            Sid = "",
            Effect = "Allow",
            Action = "dynamodb:*",
            Resource = "*"
        }
     ]
    })
}

resource "aws_iam_role" "role_for_LDC" {
  name = "dynamodbrule"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
         Action = "sts:AssumeRole"
         Principal = {
          Service = "lambda.amazonaws.com"
        },
         Effect = "Allow"
         Sid = ""
       }
     ]
    })
}

