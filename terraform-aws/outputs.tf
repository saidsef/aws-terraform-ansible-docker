output "elb_dns_name" {
  value = "${module.elb.elb_dns_name}"
}

output "ec2key_name" {
  value = "${module.ec2key.ec2key_name}"
}
