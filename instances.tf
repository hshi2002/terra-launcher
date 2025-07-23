locals {
  ec2_instances = {
    ec2_1 = {
      subnet_id = aws_subnet.main-subnet1.id
      name      = "task1-ec2-1"
    }
    ec2_2 = {
      subnet_id = aws_subnet.main-subnet2.id
      name      = "task1-ec2-2"
    }
  }
}

resource "aws_instance" "my_ec2" {
  for_each = local.ec2_instances

  ami                    = "ami-053b12d3152c0cc71"
  instance_type          = "t3a.micro"
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [aws_security_group.ssh-sg.id]
  key_name               = "KP-Master"

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y unzip apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt-get update -y
              apt-get install -y docker-ce docker-ce-cli containerd.io
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ubuntu
              docker pull adongy/hostname-docker
              docker run -p 3000:3000 -d adongy/hostname-docker
              EOF

  tags = {
    Name = each.value.name
  }
}