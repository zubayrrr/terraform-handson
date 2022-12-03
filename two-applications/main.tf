provider "aws" {
  region = var.region
}

# instance 1 
resource "aws_instance" "app_1" {
  ami                  = "ami-072bfb8ae2c884cc4"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.app_1_profile
  user_data = <<EOF 
    
  EOF

  tags = {
    Name = "Application 1"
  }
}

# bucket 1
resource "aws_s3_bucket" "app_1_bucket" {
  bucket = "app_1_bucket"
  acl    = "private"
}

# instance 2
resource "aws_instance" "app_2" {
  ami           = "ami-072bfb8ae2c884cc4"
  instance_type = "t2.micro"

  tags = {
    Name = "Application 2"
  }
}

# bucket 2
resource "aws_s3_bucket" "app_2_bucket" {
  bucket = "app_2_bucket"
  acl    = "private"
}

# policy 1

resource "aws_iam_instance_profile" "app_1_profile" {
  name = "app_1_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "app_1_role" {
  name = "app_1_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

## S3 Policy for app_1

data "aws_iam_policy_document" "aws_iam_policy_s3_1" {
  statement {
    actions = [
      "s3:Get*",
    ]

    resources = [
      "aws_s3_bucket.app_1_bucket.arn",
    ]
  }

}

resource "aws_iam_policy" "s3_1" {
  name   = "s3_1"
  path   = "/"
  policy = data.aws_iam_policy_document.aws_iam_policy_s3_1.json
}

# policy 2

resource "aws_iam_instance_profile" "app_2_profile" {
  name = "app_2_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "app_2_role" {
  name = "app_2_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

## S3 Policy for app_2

data "aws_iam_policy_document" "aws_iam_policy_s3_2" {
  statement {
    actions = [
      "s3:Put*",
      "s3:Get*",
    ]

    resources = [
      "aws_s3_bucket.app_2_bucket.arn",
    ]
  }

}

resource "aws_iam_policy" "s3_2" {
  name   = "s3_2"
  path   = "/"
  policy = data.aws_iam_policy_document.aws_iam_policy_s3_2.json
}


resource "aws_iam_role_policy_attachment" "app_1_attach" {
  role       = aws_iam_role.app_1_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "app_2_attach" {
  role       = aws_iam_role.app_2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
