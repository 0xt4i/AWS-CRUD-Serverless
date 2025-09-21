# !/bin/bash
name_stack_s3='s3-stack'
parent_packaged='template/foundation/parent.packaged.yaml'

aws cloudformation create-stack --stack-name $name_stack_s3 --template-body file://template/foundation/0.s3.yaml --output json

store_code=$(aws s3 ls | grep code | awk '{print $3}') 
store_template=$(aws s3 ls | grep template | awk '{print $3}')

aws s3 cp template/functions/*  s3://$store_template

aws cloudformation package \
  --template-file  template/foundation/1.root.yaml \
  --s3-bucket $store_template\
  --output-template-file $parent_packaged



