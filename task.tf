provider "aws" {
 region = "ap-south-1"
 profile = "pushati"
}
  resource "aws_key_pair" "task1-key1"{
  key_name = "task1-key1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCH6jbMJ1Zc5lrwUEltA9jgrW+FoQntQMIvdW43DrLHRcabHK9/YGXwGJrsB0iAiBi/ludZQZXzu6QYuhDnoeRSL1SmfAXnATPCClz7eQ8ZM+sMPiCHMudSOf7sidfYPU8TAIZx/JzVtWPydnaBpNMMRjd5dV5HfVbH8KYt1j9OEQryFI9aJb8z6NSyU+CT+n5ylCvnPXS+2ZV05KqluDxpNjUjeY+gijr/NZQtDFHxz2HpnrsGNqHr1Gstql1iIZ3zXxrzBXBbxuV4GYIoY62ETUTaA9gBuj9xwV4HH+8zV9GWEIea/lNLK1spa1T6rEP1LETlsLBbLZoV6P1l5J85"
}


 resource "aws_security_group" "task1-sg"{
 name = "task1-sg"
 description = "Allow TLS inbound traffic"
 vpc_id = "vpc-789f8210"
   
 
  ingress {
   description = "SSH"
   from_port = 22
   to_port = 22
   protocol = "tcp"
   cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task1-sg"
  }
}

resource "aws_ebs_volume" "taskebs1" {
  availability_zone = "ap-south-1a"
  size              = 1

  tags = {
    Name = "taskebs1"
  }
}
resource "aws_volume_attachment" "taskattach1" {
 device_name = "/dev/sdf"
 volume_id = "${aws_ebs_volume.taskebs1.id}"
 instance_id = "${aws_instance.taskinst1.id}"
}
resource "aws_instance" "taskinst1" {
  ami           = "ami-01f573c6a105607e9"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name      = "task1-key1"
  security_groups = [ "task1-sg" ]
  user_data = <<-EOF
                #! /bin/bash
                sudo yum install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                sudo yum install git -y
                mkfs.ext4 /dev/xvdf1
                mount /dev/xvdf1 /var/www/html
                cd /var/www/html
                git clone https://github.com/payal024/hcctask1.git
                
  EOF

  tags = {
    Name = "taskinst1"
  }
}
