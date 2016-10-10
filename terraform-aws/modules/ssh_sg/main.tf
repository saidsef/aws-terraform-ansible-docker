resource "aws_security_group" "ssh_sg" {
    name = "${var.name}-${var.environment}-ssh"
    description = "${var.name}-${var.environment}Security Group"
    vpc_id = "${var.vpc_id}"
    tags {
      Name = "${var.name}-${var.environment}-ssh"
      environment =  "${var.name}-${var.environment}"
    }
    // allows traffic from the SG itself
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    // allow traffic for TCP 22
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.source_cidr_block}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "ssh_sg_id" {
  value = "${aws_security_group.ssh_sg.id}"
}
