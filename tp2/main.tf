resource "aws_instance" "foo" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name = "fsa-cloud4-kp"
  tags = {
    Name = "fsa-ec2-test"
  }
}

resource "aws_instance" "foo1" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name = "fsa-cloud4-kp"
  tags = {
    Name = "fsa-ec2-test1"
  }
}