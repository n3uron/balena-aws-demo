data "aws_ami" "ubuntu_22" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_eip" "n3uron" {
  instance = aws_instance.n3uron.id
}

resource "aws_instance" "n3uron" {
  ami                    = data.aws_ami.ubuntu_22.id
  instance_type          = "t4g.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.n3uron.id]

  tags = {
    Name = "sunn3rgy-eu-prod-01/n3uron"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
  }

  user_data = <<-EOF
      #!/bin/bash
      curl -fsSL https://get.n3uron.com/install.sh | sudo bash
    EOF
}

resource "aws_instance" "mongodb" {
  ami                    = data.aws_ami.ubuntu_22.id
  instance_type          = "t4g.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.mongodb.id]

  tags = {
    Name = "sunn3rgy-eu-prod-01/mongo"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
  }

  user_data = <<-EOF
      #!/bin/bash

      # Install Docker Engine
      curl -fsSL https://get.docker.com | sudo bash
      
      docker run -d --name mongodb-1 -p 27017:27017 mongo:7
    EOF
}

output "n3uron_public_address" {
  value = "https://${aws_eip.n3uron.public_dns}:8443"
}

output "mongodb_connection_url" {
  value = "mongodb://${aws_instance.mongodb.private_dns}:27017/history?retryWrites=true"
}
