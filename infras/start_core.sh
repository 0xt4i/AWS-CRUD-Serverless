# !/bin/bash
set -e

parent_packaged='template/core/parent.packaged.yaml'

aws cloudformation create-stack \
    --stack-name project1-stack \
    --template-body file://$parent_packaged \
    --capabilities CAPABILITY_NAMED_IAM

