resource "aws_s3_bucket" "name" {
  bucket = "how-to-train-ur-dragon"
}

resource "aws_s3_object" "name" {
  bucket = aws_s3_bucket.name.id
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
  s3_bucket     = aws_s3_bucket.name.id  # S3 bucket where the Lambda deployment package (ZIP) is stored
  s3_key        = aws_s3_object.name.key # S3 object key (ZIP file name) used by Lambda
  memory_size      = 128
  handler          = "app.lambda_handler"
  source_code_hash = filebase64sha256("app.zip")

}



# 1. aws_s3_bucket
# - Creates an S3 bucket to store Lambda deployment package
# - Bucket must have a globally unique name

# 2. aws_s3_object
# - Uploads the Lambda ZIP file to S3
# - key = object name inside the bucket
# - source = local file path
# - etag tracks file changes using MD5 hash

# 3. aws_iam_role
# - IAM role assumed by AWS Lambda
# - sts:AssumeRole allows Lambda service to use this role

# 4. aws_iam_role_policy_attachment
# - Attaches AWS managed policy to IAM role
# - AWSLambdaBasicExecutionRole enables CloudWatch logging

# 5. aws_lambda_function
# - Defines the Lambda function
# - Uses S3 as the code source (s3_bucket + s3_key)
# - handler = file_name.function_name
# - runtime = language runtime version
# - memory_size and timeout control performance
# - source_code_hash forces Lambda update when ZIP changes

# 6. Lambda code source rule
# - Lambda must use ONLY ONE of the following:
#   - filename (local ZIP)
#   - s3_bucket + s3_key (S3 ZIP) ✅
#   - image_uri (container image)

# 7. Best Practice
# - Use S3-based Lambda for production
# - Always use source_code_hash for code change detection
# - Use depends_on to avoid IAM permission timing issues
