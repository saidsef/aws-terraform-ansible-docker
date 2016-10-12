#!/bin/sh

set -e

# Set script variables
APP=$1
ACC=$2
SERV=$3
SIZE=$4

usage() {
  if [ -z "${APP}" ] || [ -z "${ACC}" ] || [ -z "${SERV}" ] || [ -z "${SIZE}" ]; then
    echo """
      $1 - $2 - $3 - $4 - $# - $@
      To run this script you to need to supply 4 arguments:
      $0 <app> <environment> <num_servers> <server_size>
    """
    exit 1
  else
    echo "arguments are set ...."
  fi
  if [ -z "${AWS_SECRET_ACCESS_KEY}" ] || [ -z "${AWS_ACCESS_KEY_ID}" ]; then
    echo """
      Please make sure you've set your AWS credentials i.e:
      export AWS_ACCESS_KEY_ID=xxxx
      export AWS_SECRET_ACCESS_KEY=yyyy
    """
    exit 1
  else
    echo "AWS stuff are set ...."
  fi

}

main() {
  usage
  runTerraform
}

runTerraform() {
  export PATH=$PATH:/opt/terraform
  cd ./terraform-aws
  terraform get
  terraform apply \
  -var "application=${APP:-app}" \
  -var "environment=${ACC:-dev}" \
  -var 'count="'${SERV:-1}'"' \
  -var "instance_type=${SIZE:-t2.nano}"
  if [ $? -eq 0 ]; then
    echo "Waiting for AWS resources ...."
    sleep 185
    INSTANCES_IPS="`aws ec2 describe-instances --filter Name=tag:Name,Values=said-sef-${APP}* --query "Reservations[*].Instances[*].PublicIpAddress" --output text`"
    echo "#################"
    echo "Instance(s) IP Address"
    echo "${INSTANCES_IPS}"
    echo "#################"
    cd ..
    ./ips_to_file.py './ansible/' "${INSTANCES_IPS}"
    cd ansible
    ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i hosts playbook.yml
  else
    echo "Terraform didn't complete successfully!"
    exit 1
  fi
}

main
