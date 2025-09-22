#!/bin/bash
set -e
set -u  # Báo lỗi nếu dùng biến chưa được gán
set -o pipefail  # Báo lỗi nếu lệnh trong pipeline bị lỗi

# Khai báo biến
 name_stack_s3='s3-project1-stack'
 parent_packaged='template/core/parent.packaged.yaml'

echo "🚀 Tạo stack S3: $name_stack_s3"
aws cloudformation create-stack \
  --stack-name "$name_stack_s3" \
  --template-body file://template/foundation/0.s3.yaml \
  --output json
echo "⏳ Chờ stack S3 hoàn tất..."
# Lấy tên bucket chứa 'code' và 'template'
store_code=$(aws s3 ls | grep code | awk '{print $3}')
echo "Debug store_code:"
echo $store_code
store_template=$(aws s3 ls | grep template | awk '{print $3}')
echo "Debug store_template:"
echo $store_template
# Kiểm tra biến có rỗng không
if [ -z "$store_code" ]; then
  echo "❌ Không tìm thấy bucket chứa 'code'"
  exit 1
fi

if [ -z "$store_template" ]; then
  echo "❌ Không tìm thấy bucket chứa 'template'"
  exit 1
fi
echo "📦 Bucket code: $store_code"
echo "📦 Bucket template: $store_template"

# Upload mã nguồn lên S3
echo "📤 Upload mã nguồn lên S3 bucket: $store_code"
aws s3 cp template/functions/ s3://"$store_code" --recursive

# Package CloudFormation template
echo "📦 Đóng gói template với bucket: $store_template"
aws cloudformation package \
  --template-file template/core/1.root.yaml \
  --s3-bucket "$store_template" \
  --output-template-file "$parent_packaged"

echo "✅ Hoàn tất!"
