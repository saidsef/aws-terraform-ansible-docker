resource "aws_security_group" "app_sg" {
    name = "${var.name}-${var.environment}"
    description = "${var.name}-${var.environment} Security Group"
    vpc_id = "${var.vpc_id}"
    tags {
      Name = "${var.name}-${var.environment}"
      environment =  "${var.environment}"
    }
    // allows traffic from the SG itself
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }
    // allow traffic for TCP 80
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.source_cidr_block}"]
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

output "app_sg_id" {
  value = "${aws_security_group.app_sg.id}"
}
