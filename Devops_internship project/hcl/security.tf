resource "aws_security_group" "rdp_sg" {
  name        = "allow-rdp-winrm"
  description = "Allow RDP and WinRM access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "RDP from your IP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["122.161.48.38/32"]
  }

  ingress {
    description = "WinRM from your IP"
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = ["122.161.48.38/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDP-WinRM-Access"
  }
}

data "aws_vpc" "default" {
  default = true
}
