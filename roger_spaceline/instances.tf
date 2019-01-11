variable "ec2_type" {}
variable "ami_id" {}
variable "main_key_pair" {}

resource "aws_instance" "public" {
  ami           = "${var.ami_id}"
  instance_type = "${var.ec2_type}"
	subnet_id = "${aws_subnet.public.id}"
	key_name = "${var.main_key_pair}"
	security_groups = ["${aws_security_group.ping_ssh.id}"]

  tags = {
    Name = "public"
  }
}

resource "aws_instance" "private" {
  ami           = "${var.ami_id}"
  instance_type = "${var.ec2_type}"
	subnet_id = "${aws_subnet.private.id}"
	key_name = "${var.main_key_pair}"
	security_groups = ["${aws_security_group.ping_ssh.id}"]

  tags = {
    Name = "private"
  }
}
