# !/bin/bash

aws cloudformation create-stack \
    --stack-name project_1 \
    --template-body file://$parent_packaged \
    --output json

