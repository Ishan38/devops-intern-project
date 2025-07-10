resource "aws_instance" "my_ec2" {
  ami                         = "ami-00f9931538f5c9ae4"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.rdp_sg.id]

  user_data = <<-EOF
              <powershell>
              # Enable RDP
              Set-ItemProperty -Path 'HKLM:\\System\\CurrentControlSet\\Control\\Terminal Server' -Name "fDenyTSConnections" -Value 0
              Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

              # Enable WinRM
              winrm quickconfig -quiet
              winrm set winrm/config/service '@{AllowUnencrypted="true"}'
              winrm set winrm/config/service/auth '@{Basic="true"}'

              # Create listener for HTTP on port 5985
              winrm delete winrm/config/Listener?Address=*+Transport=HTTP
              winrm create winrm/config/Listener?Address=*+Transport=HTTP '@{Port="5985"}'

              # Allow WinRM through firewall
              netsh advfirewall firewall add rule name="WinRM HTTP" dir=in action=allow protocol=TCP localport=5985
              </powershell>
              EOF

  tags = {
    Name = "Windows-EC2"
  }
}
