# Deploy
## Define variable enviroment
```bash
name_stack='s3-stack'

```
## Create S3 bucket
```bash
aws cloudformation create-stack --stack-name s3-stack --template-body file://template/foundation/0.s3.yaml --output json
```

## Variable of name bucket
```bash
ARTIFACTS_BUCKET='873152456775-us-east-1-s3-stack-artifacts'
```

## Upload parent and nested file on S3
```bash
aws s3 cp template/foundation/2.dynamodb.yaml  s3://873152456775-us-east-1-s3-stack
aws s3 cp template/foundation/3.iam-lambda.yaml  s3://873152456775-us-east-1-s3-stack
```

```bash
aws cloudformation package \
  --template-file  template/foundation/1.root.yaml \
  --s3-bucket 873152456775-us-east-1-s3-stack\
  --output-template-file template/foundation/parent.packaged.yaml


```bash
aws cloudformation create-stack --stack-name project-1 --template-body file://template/foundation/parent.packaged.yaml --output json

```

```
aws cloudformation deploy --stack-name project-1 \
  --template file://template/foundation/parent.packaged.yaml \
  --capabilities CAPABILITY_NAMED_IAM
```

