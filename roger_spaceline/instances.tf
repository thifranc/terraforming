variable "ec2_type" {}
variable "ami_id" {}
variable "main_key_pair" {}

resource "aws_instance" "nat_inst" {
  ami           = "${var.ami_id}"
  instance_type = "${var.ec2_type}"
  subnet_id = "${aws_subnet.public.id}"
  key_name = "${var.main_key_pair}"
  security_groups = ["${aws_security_group.natting.id}"]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -qq install python -y",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("~/Downloads/thibault.pem")}"
    }
  }

  tags = {
    Name = "nat_inst"
  }
}

resource "aws_instance" "ldap_inst" {
  ami           = "${var.ami_id}"
  instance_type = "${var.ec2_type}"
  subnet_id = "${aws_subnet.private.id}"
  key_name = "${var.main_key_pair}"
  security_groups = ["${aws_security_group.ping_ssh.id}"]

  tags = {
    Name = "ldap_inst"
  }
}

#provisioner "local-exec" {
#    command = "ansible-playbook --extra-vars @${local_file.ansible_vars.filename} ./ansible/site.yml"
#
#    environment {
#      ANSIBLE_CONFIG = "./ansible.cfg"
#    }
#}

resource "local_file" "ansible_vars" {
  filename = "./ansible/ansible_vars.yml"
  content = <<EOF
  country_code: 'FR'
  domain:
    name: pseudo #slash16
    extension: moi #com
  network:
    CIDR: ${ var.cidr }
    address: ${ cidrhost(var.cidr_private, 0) }
    subnet: ${ cidrhost(var.cidr_private, 0) }
    dns: ${ cidrhost(var.cidr_private, 252) }
    dhcp: ${ cidrhost(var.cidr_private, 253) }
    gateway: ${ cidrhost(var.cidr_private, 254) }
    broadcast: ${ cidrhost(var.cidr_private, 255) }
    netmask: ${ cidrnetmask(var.cidr_private) }
  hosts:
    ldap:
      ip: ${aws_instance.ldap_inst.private_ip}
      ports:
        - { src: 4003, dst: 22 }
    nat:
      ip: ${aws_instance.nat_inst.public_ip}
  EOF
  }
