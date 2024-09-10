provider "aws" {
  region = "us-east-1"  
}

resource "aws_security_group" "allow_http" {
  name_prefix = "allow_http"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami             = "ami-0182f373e66f89c85"  
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_http.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<html><h2>Hello World</h2></html>" > /var/www/html/index.html
            EOF

  tags = {
    Name = "terraform-ec2-hello-world"
  }
}

output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Use este IP público para acessar o servidor."
}
