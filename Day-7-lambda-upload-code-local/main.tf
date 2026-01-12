resource "aws_iam_role" "name" {
  name = "lambda-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["sts:AssumeRole"],
            "Principal": {
                "Service": ["lambda.amazonaws.com"]
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
  runtime = "python3.12"
  timeout = 900
  role = aws_iam_role.name.arn
  memory_size = 128
  handler = "lambda_function.lambda_handler"
  filename = "lambda_function.zip" #Uploading app.zip locally to Lambda using filename
  source_code_hash = filebase64sha256("lambda_function.zip")
}
