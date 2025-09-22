# !/bin/bash
set -e

parent_packaged='template/core/parent.packaged.yaml'

aws cloudformation create-stack \
    --stack-name project-1 \
    --template-body file://$parent_packaged \
    --output json

