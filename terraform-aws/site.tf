# Provider spcific
provider "aws" {
  region = "eu-west-1"
}

# Variables for VPC module
module "vpc_subnets" {
  source               = "./modules/vpc_subnets"
  name                 = "${var.name}-${var.application}"
  environment          = "${var.environment}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  vpc_cidr             = "172.16.0.0/16"
  public_subnets_cidr  = "172.16.10.0/24,172.16.20.0/24"
  private_subnets_cidr = "172.16.30.0/24,172.16.40.0/24"
  azs                  = "eu-west-1a,eu-west-1b"
}

module "ssh_sg" {
  source            = "./modules/ssh_sg"
  name              = "${var.name}-${var.application}"
  environment       = "${var.environment}"
  vpc_id            = "${module.vpc_subnets.vpc_id}"
  source_cidr_block = "0.0.0.0/0"
}

module "app_sg" {
  source            = "./modules/app_sg"
  name              = "${var.name}-${var.application}"
  environment       = "${var.environment}"
  vpc_id            = "${module.vpc_subnets.vpc_id}"
  source_cidr_block = "0.0.0.0/0"
}

module "elb_sg" {
  source      = "./modules/elb_sg"
  name        = "${var.name}-${var.application}"
  environment = "${var.environment}"
  vpc_id      = "${module.vpc_subnets.vpc_id}"
}

module "ec2key" {
  source     = "./modules/ec2key"
  key_name   = "${var.name}"
  public_key = "${var.public_key}"
}

module "elb" {
  source             = "./modules/elb"
  name               = "${var.name}-${var.application}"
  environment        = "${var.environment}"
  security_groups    = "${module.elb_sg.elb_sg_id},${module.app_sg.app_sg_id}"
  availability_zones = "eu-west-1a,eu-west-1b"
  subnets            = "${module.vpc_subnets.public_subnets_id}"
}

module "asg" {
  source              = "./modules/asg"
  name                = "${var.name}-${var.application}"
  environment         = "${var.environment}"
  availability_zones  = "eu-west-1a,eu-west-1b"
  vpc_zone_identifier = "${module.vpc_subnets.public_subnets_id}"
  load_balancers      = "${module.elb.elb_name}"
  key_name            = "${module.ec2key.ec2key_name}"
  instance_type       = "${var.instance_type}"
  count               = "${var.count}"
  security_groups     = "${module.elb_sg.elb_sg_id},${module.app_sg.app_sg_id}"
}
