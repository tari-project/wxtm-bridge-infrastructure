DEV_PARAMETERS_FILE=template-config.dev.json
DEV_PARAMETERS=$(shell cat $(DEV_PARAMETERS_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
DEV_REGION=us-east-1
DEV_ARTIFACTS_BUCKET_NAME=artifacts.wxtm-bridge
DEV_ARTIFACTS_S3_PREFIX=dev/infrastructure
DEV_STACK_NAME=wxtm-bridge-dev

PROD_PARAMETERS_FILE=template-config.prod.json
PROD_PARAMETERS=$(shell cat $(PROD_PARAMETERS_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
PROD_REGION=eu-central-1
PROD_ARTIFACTS_BUCKET_NAME=artifacts.wxtm-bridge-prod
PROD_ARTIFACTS_S3_PREFIX=prod/infrastructure
PROD_STACK_NAME=wxtm-bridge-prod


TEMPLATE_FILE=main.yml
CAPABILITIES=CAPABILITY_IAM CAPABILITY_AUTO_EXPAND

VERSION=current
ARTIFACT_NAME=main.zip

.PHONY: deploy-dev deploy-prod

copy-s3-zip-files-dev:
	 @../scripts/is_correct_aws_account.sh dev
	 aws s3 cp s3://$(DEV_ARTIFACTS_BUCKET_NAME)/dev/wxtm-bridge/wxtm-bridge-backend.zip .
	 aws s3 cp s3://$(DEV_ARTIFACTS_BUCKET_NAME)/dev/wxtm-bridge/wxtm-bridge-migrations.zip .
	 aws s3 cp s3://$(DEV_ARTIFACTS_BUCKET_NAME)/dev/wxtm-bridge/wxtm-bridge-subgraph.zip .
	 aws s3 cp s3://$(DEV_ARTIFACTS_BUCKET_NAME)/dev/wxtm-bridge/wxtm-bridge-timeout.zip .
	 aws s3 cp s3://$(DEV_ARTIFACTS_BUCKET_NAME)/dev/wxtm-bridge/wxtm-bridge-notifications.zip .


copy-s3-zip-files-prod:
	 @../scripts/is_correct_aws_account.sh prod-backend
	 aws s3 cp s3://$(PROD_ARTIFACTS_BUCKET_NAME)/prod/wxtm-bridge/wxtm-bridge-backend.zip .
	 aws s3 cp s3://$(PROD_ARTIFACTS_BUCKET_NAME)/prod/wxtm-bridge/wxtm-bridge-migrations.zip .
	 aws s3 cp s3://$(PROD_ARTIFACTS_BUCKET_NAME)/prod/wxtm-bridge/wxtm-bridge-subgraph.zip .
	 aws s3 cp s3://$(PROD_ARTIFACTS_BUCKET_NAME)/prod/wxtm-bridge/wxtm-bridge-timeout.zip .
	 aws s3 cp s3://$(PROD_ARTIFACTS_BUCKET_NAME)/dev/wxtm-bridge/wxtm-bridge-notifications.zip .


build-dev: copy-s3-zip-files-dev
	sam build

build-prod: copy-s3-zip-files-prod
	sam build

upload-dev: build-dev
	sam package --output-template-file $(TEMPLATE_FILE) --s3-bucket $(DEV_ARTIFACTS_BUCKET_NAME) --s3-prefix $(DEV_ARTIFACTS_S3_PREFIX)/$(VERSION) --region $(DEV_REGION)
	zip $(ARTIFACT_NAME) $(TEMPLATE_FILE) $(DEV_PARAMETERS_FILE) Makefile
	aws s3 cp $(ARTIFACT_NAME) s3://$(DEV_ARTIFACTS_BUCKET_NAME)/$(DEV_ARTIFACTS_S3_PREFIX)/$(VERSION)/ --region $(DEV_REGION)

upload-prod: build-prod
	sam package --output-template-file $(TEMPLATE_FILE) --s3-bucket $(PROD_ARTIFACTS_BUCKET_NAME) --s3-prefix $(PROD_ARTIFACTS_S3_PREFIX)/$(VERSION) --region $(PROD_REGION)
	zip $(ARTIFACT_NAME) $(TEMPLATE_FILE) $(PROD_PARAMETERS_FILE) Makefile
	aws s3 cp $(ARTIFACT_NAME) s3://$(PROD_ARTIFACTS_BUCKET_NAME)/$(PROD_ARTIFACTS_S3_PREFIX)/$(VERSION)/ --region $(PROD_REGION)

deploy-dev-ci:
	sam deploy --template-file $(TEMPLATE_FILE) --stack-name $(DEV_STACK_NAME) --capabilities $(CAPABILITIES)  --region $(DEV_REGION) --parameter-overrides $(DEV_PARAMETERS)

deploy-prod-ci:
	sam deploy --template-file $(TEMPLATE_FILE) --stack-name $(PROD_STACK_NAME) --capabilities $(CAPABILITIES)  --region $(PROD_REGION) --parameter-overrides $(PROD_PARAMETERS)

deploy-dev: upload-dev
	sam deploy --template-file $(TEMPLATE_FILE) --stack-name $(DEV_STACK_NAME) --capabilities $(CAPABILITIES)  --region $(DEV_REGION) --parameter-overrides $(DEV_PARAMETERS)

deploy-prod: upload-prod
	sam deploy --template-file $(TEMPLATE_FILE) --stack-name $(PROD_STACK_NAME) --capabilities $(CAPABILITIES)  --region $(PROD_REGION) --parameter-overrides $(PROD_PARAMETERS)

deploy-prod-backend-log-export:
	@../scripts/is_correct_aws_account.sh prod-backend
	sam deploy --template-file log-export.yml --stack-name $(PROD_STACK_NAME)-log-export --capabilities $(CAPABILITIES)  --region $(PROD_REGION) --parameter-overrides LogsExportBucketName=log-export.backend.bridge.tari.com
