# resource "aws_instance" "name" {
#   ami           = "ami-068c0051b15cdb816"
#   instance_type = "t2.medium"
#   tags = {
#     Name = "test"
#   }

#   provisioner "local-exec" {
#   command = "echo I am running on ${aws_instance.name.public_ip}"
# }
# }

resource "aws_s3_bucket" "bucket" {
  bucket = "how-to-train-ur-dragon"
  provisioner "local-exec" {
    command = "aws s3 cp file.txt s3://${aws_s3_bucket.bucket.bucket}/file.txt"
  }
}
