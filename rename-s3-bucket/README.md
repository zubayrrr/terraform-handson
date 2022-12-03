# Rename S3 Bucket

## Requirements

* An existing S3 bucket tracked by Terraform.
If you don't have it, you can use the following block and run `terraform apply`:

```terraform
resource "aws_s3_bucket" "some_bucket" {
    bucket = "some-old-bucket"
```

## Objectives

1. Rename an existing S3 bucket and make sure it's still tracked by Terraform

## Solution

resource "aws_s3_bucket" "demo-bucket" {
    bucket = "old-demo-bucket-randomhash-121321312"
}


```bash
aws s3 mv s3://old-demo-bucket-randomhash-121321312 s3://new-demo-bucket-randomhash-121321312
```

```terraform
resource "aws_s3_bucket" "demo-bucket" {
    bucket = "old-demo-bucket-randomhash-121321312"
}
```

```bash
terraform state mv aws_s3_bucket.demo-bucket  aws_s3_bucket.new-demo-bucket-randomhash-121321312
```


`terraform apply`
