#!/bin/bash -x
db_user=$(aws ssm get-parameter --name wp-db-user --query 'Parameter.Value')
db_password=$(aws ssm get-parameter --name wp-db-password --with-decryption --query 'Parameter.Value')

echo "db_user is ${db_user}\n{db_password} is ${db_password}"

sed -i "s/{db_user}/${db_user}/g" ../terraform/rds/environment.tfvars
sed -i "s/{db_password}/${db_password}/g" ../terraform/rds/environment.tfvars