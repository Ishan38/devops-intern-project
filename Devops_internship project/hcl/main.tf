resource "aws_instance" "my_ec2" {
  ami                         = "ami-00f9931538f5c9ae4"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.rdp_sg.id]

  # Enable RDP via user_data
  user_data = <<-EOF
              <powershell>
              Set-ItemProperty -Path 'HKLM:\\System\\CurrentControlSet\\Control\\Terminal Server' -Name "fDenyTSConnections" -Value 0
              Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
              </powershell>
              EOF

  tags = {
    Name = "Windows-EC2"
  }
}
