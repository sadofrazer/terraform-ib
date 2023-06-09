data "aws_ami" "my_ami" {

  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal*"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

}


resource "aws_instance" "frazer-ec2" {
  ami             = data.aws_ami.my_ami.id
  instance_type   = var.instance_type
  key_name        = "fsa-cloud4-kp"
  security_groups = ["${aws_security_group.my_sg.name}"]
  tags = {
    Name = "${var.author}-ec2-web"
  }


  provisioner "remote-exec" {

    inline = [
      "sudo apt-get update -y",
      "sudo apt-get -y install nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type   = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/sadofrazer/Données/DevOps/AWS/.aws/fsa-cloud4-kp.pem")
      host        = self.public_ip
    }
  }


}


resource "aws_security_group" "my_sg" {
  name        = "${var.author}-sg-web"
  description = "Allow http and https inbound traffic"
  #vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from all"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from all"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    description      = "HTTPS from all"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.author}-sg-web"
  }
}

resource "aws_eip" "my_eip" {
  domain   = "vpc"
  instance = aws_instance.frazer-ec2.id
  tags = {
    Name = "${var.author}-webserver-eip"
  }

  provisioner "local-exec" {
    command = "echo '${aws_instance.frazer-ec2.tags.Name} [PUBLIC IP : ${aws_eip.my_eip.public_ip} , ID: ${aws_instance.frazer-ec2.id} , AZ: ${aws_instance.frazer-ec2.availability_zone}]' >> infos-ec2.txt"
  }

}