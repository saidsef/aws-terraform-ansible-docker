# Basic Terraform Help

### Prerequisite:

Make sure the following applications are installed and are set in the enviromental path:

- AWS CLI >= 1.10
- Terraform >= 0.7.5
- Ansible >= 2.1.2.0

Export your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as environment variables, and run `aws configure` to complete setup:

```shell
export AWS_ACCESS_KEY_ID=<access-key>
export AWS_SECRET_ACCESS_KEY=<secret-key>
```

Also, update `public_key` variable with your public ssh key, the file is located at `terraform-aws/variables.tf`

### Assumptions

This will run in Amazon AWS region eu-west-1, and you will only need AZA and AZB ;)

### AWS resources

This application will create the following resources:

 * VPC
 * Routing
 * Subnets
 * Internet Gateway
 * Security Groups
 * Elatic Loadbalance
 * Autoscaling Groups
 * EC2 Key
 * EC2 Instance(s)

**Note**: Some of these resource will incur a charge

### Files and Directories:

```
├── ansible
│   ├── hosts.template
│   └── playbook.yml
├── cloud-automation.sh
├── docker
│   └── docker-compose.yml
├── nginx
│   ├── nginx.conf
│   └── proxy.conf
├── README.md
└── terraform-aws
    ├── modules
    │   ├── app_sg
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── asg
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── ec2key
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── elb
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── elb_sg
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── ssh_sg
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   └── vpc_subnets
    │       ├── main.tf
    │       └── variables.tf
    ├── outputs.tf
    ├── site.tf
    ├── userdata.sh
    └── variables.tf
```
### Getting started

To run the application, simply execute the following command:
```shell
./cloud-automation.sh web dev 1 t2.nano
```

### Tools Used:

Terraform: To compile, test, run and destroy,
```shell
terraform validate
terraform get
terraform plan
terraform graph
terraform apply
terraform show
terraform destroy
```
Terraform will create all the resources in AWS, you can then use ansible-playbook to deploy applications and docker compose.

Ansible playbook: To run:
```shell
ansible-playbook -i hosts playbook.yml
```
**Note**: Terraform stores the state of the managed infrastructure from the last time Terraform was run. Terraform uses the state to create plans and make changes to the infrastructure.
