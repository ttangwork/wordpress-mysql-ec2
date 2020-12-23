#!/bin/bash -x

# creating ssm param for wp-db-user
aws ssm put-parameter \
--region "ap-southeast-2" \
--name "wp-db-user" \
--description "Database user" \
--value "wp_db_user" \
--type "String" \
--overwrite

# creating ssm param for wp-db-password
set +x


KMS_KEY_ARN="arn:aws:kms:ap-southeast-2:461161570059:alias/wordpress_mysql_kms_key"

ssm_param_check=$(aws ssm get-parameters \
                --region "ap-southeast-2" \
                --names "wp-db-password" \
                --with-decryption \
                --query "Parameters[0].Value" | tr -d '"')

if [ "$ssm_param_check" = "null" ]; then
    echo "Creating the password as it doesn't exist"
    GENERATED_PASSWORD=$(</dev/urandom tr -dc 'A-Za-z0-9#%' | head -c 32)

    aws ssm put-parameter \
    --region "ap-southeast-2" \
    --name "wp-db-password" \
    --description "Database password" \
    --value "${GENERATED_PASSWORD}" \
    --type "SecureString" \
    --key-id ${KMS_KEY_ARN} \
    --overwrite
    
    unset GENERATED_PASSWORD
else
    echo "The password already exists!"
fi

db_user=$(aws ssm get-parameter --name wp-db-user --query 'Parameter.Value'|tr -d '"')
db_password=$(aws ssm get-parameter --name wp-db-password --with-decryption --query 'Parameter.Value'|tr -d '"')

sed -i "s/{db_user}/${db_user}/g" ../terraform/rds/environment.tfvars
sed -i "s/{db_password}/${db_password}/g" ../terraform/rds/environment.tfvars

