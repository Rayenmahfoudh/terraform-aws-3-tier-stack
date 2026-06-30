#Policy
resource "aws_iam_policy" "ec2_readonly" {
  name        = "patientping-ec2-readonly"
  description = "Read-only access to EC2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe*"]
        Resource = "*"
      }
    ]
  })
}

#Group
resource "aws_iam_group" "readers" {
  name = "patientping-ec2-readers"
}

resource "aws_iam_group_policy_attachment" "readers_readonly" {
  count      = var.is_local ? 0 : 1
  group      = aws_iam_group.readers.name
  policy_arn = aws_iam_policy.ec2_readonly.arn
}

#User
resource "aws_iam_user" "vinny" {
  name          = "patientping-admin-vinny"
  force_destroy = true
}

resource "aws_iam_group_membership" "readers" {
  name  = "patientping-ec2-readers-membership"
  group = aws_iam_group.readers.name
  users = [aws_iam_user.vinny.name]
}

#Role
resource "aws_iam_role" "ec2_readonly" {
  name = "patientping-ec2-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = { Name = "patientping-ec2-readonly-role" }
}

resource "aws_iam_role_policy_attachment" "ec2_readonly" {
  role       = aws_iam_role.ec2_readonly.name
  policy_arn = aws_iam_policy.ec2_readonly.arn
}

resource "aws_iam_role_policy" "ssm_access" {
  name = "patientping-ssm-access"
  role = aws_iam_role.ec2_readonly.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["ssm:GetParameter", "ssm:GetParameters"]
        Resource = [
          "arn:aws:ssm:*:*:parameter/DATABASE_URL",
          "arn:aws:ssm:*:*:parameter/CMO_NAME"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "patientping-monitoring-role" {
  name = "patientping-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = { Name = "patientping-monitoring-role" }
}

resource "aws_iam_role_policy" "patientping-ssm-access" {
  name = "patientping-ssm-access"
  role = aws_iam_role.patientping-monitoring-role.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
        ],
        "Resource" : ["arn:aws:logs:*:*:*"]
        }, {
        "Effect" : "Allow",
        "Action" : ["ssm:GetParameter", "ssm:GetParameters"],
        "Resource" : [
          "arn:aws:ssm:*:*:parameter/DATABASE_URL",
          "arn:aws:ssm:*:*:parameter/CMO_NAME"
        ]
      }
    ]
  })
}


#Instance Profile
resource "aws_iam_instance_profile" "ec2" {
  name = "patientping-ec2-profile"
  role = aws_iam_role.ec2_readonly.name
}

resource "aws_iam_instance_profile" "ec2_monitoring" {
  name = "patientping-ec2-monitoring-profile"
  role = aws_iam_role.patientping-monitoring-role.name
}
