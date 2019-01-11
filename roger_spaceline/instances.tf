
resource "aws_instance" "public" {
  ami           = "${var.ami_id}"
  instance_type = "${var.ec2_type}"
	subnet_id = "aws_subnet.public.id"
	key_name = "${var.main_key_pair}"

  tags = {
    Name = "public"
  }
}

resource "aws_instance" "private" {
  ami           = "${var.ami_id}"
  instance_type = "${var.ec2_type}"
	subnet_id = "aws_subnet.private.id"
	key_name = "${var.main_key_pair}"

  tags = {
    Name = "private"
  }
}
