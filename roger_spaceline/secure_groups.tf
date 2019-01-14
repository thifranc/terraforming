
resource "aws_security_group" "ping_ssh" {
  name        = "ping_ssh"
  description = "Allow ping and SSH from all inbound"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# trick to get my public IP
#data "http" "icanhazip" {
#   url = "http://icanhazip.com"
#}

resource "aws_security_group" "natting" {
  name        = "natting"
  description = "Allow TCP on all ports from me only"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 10000
    protocol    = "tcp"
    #cidr_blocks = ["${data.http.icanhazip.body}/32"]
    cidr_blocks = ["62.210.32.239/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
