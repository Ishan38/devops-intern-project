resource "aws_instance" "my_ec2" {
  ami           = "ami-00f9931538f5c9ae4"
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "Terraform-Test"
  }
}
