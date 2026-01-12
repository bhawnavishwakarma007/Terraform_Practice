# data "aws_vpc" "vpc" {
#   filter {
#     name   = "tag:Name"
#     values = ["vpc"]
#   }
# }
# resource "aws_subnet" "name" {
#   vpc_id            = data.aws_vpc.vpc.id #using data source's vpc id
#   cidr_block        = "10.0.0.0/24"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "subnet"
#   }
# }
data "aws_s3_bucket" "name" {
  bucket = "how-to-train-ur-dragonnn"
}

resource "aws_s3_object" "name" {
  bucket = data.aws_s3_bucket.name.id
  key    = "app.zip"          #key = "app.py" for single file
  source = "app.zip"          #source = "app.py"
  etag   = filemd5("app.zip") #etag = filemd5("app.py")

}
resource "aws_iam_role" "name" {
  name = "lambda-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["sts:AssumeRole"],
        "Principal" : {
          "Service" : ["lambda.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "name" {
  role       = aws_iam_role.name.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "name" {
  function_name = "lambda"
  runtime       = "python3.12"
  timeout       = 900
  role          = aws_iam_role.name.arn
  s3_bucket     = data.aws_s3_bucket.name.id  # S3 bucket where the Lambda deployment package (ZIP) is stored
  s3_key        = aws_s3_object.name.key # S3 object key (ZIP file name) used by Lambda
  memory_size      = 128
  handler          = "app.lambda_handler"
  source_code_hash = filebase64sha256("app.zip")

}

