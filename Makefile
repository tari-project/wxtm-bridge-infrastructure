DEV_PARAMETERS_FILE=template-config.dev.json
DEV_PARAMETERS=$(shell cat $(DEV_PARAMETERS_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
DEV_REGION=us-east-1
DEV_ARTIFACTS_BUCKET_NAME=artifacts.wxtm-bridge
DEV_ARTIFACTS_S3_PREFIX=dev/infrastructure
DEV_STACK_NAME=wxtm-bridge-dev

TEMPLATE_FILE=main.yml
CAPABILITIES=CAPABILITY_IAM CAPABILITY_AUTO_EXPAND

VERSION=current
ARTIFACT_NAME=main.zip

.PHONY: deploy-dev

copy-s3-zip-files-dev:
	 aws s3 cp s3://$(DEV_ARTIFACTS_BUCKET_NAME)/dev/wxtm-bridge/wxtm-bridge-backend.zip .
	 aws s3 cp s3://$(DEV_ARTIFACTS_BUCKET_NAME)/dev/wxtm-bridge/wxtm-bridge-migrations.zip .
	 aws s3 cp s3://$(DEV_ARTIFACTS_BUCKET_NAME)/dev/wxtm-bridge/wxtm-bridge-subgraph.zip .

build-dev: copy-s3-zip-files-dev
	sam build

upload-dev: build-dev
	sam package --output-template-file $(TEMPLATE_FILE) --s3-bucket $(DEV_ARTIFACTS_BUCKET_NAME) --s3-prefix $(DEV_ARTIFACTS_S3_PREFIX)/$(VERSION) --region $(DEV_REGION)
	zip $(ARTIFACT_NAME) $(TEMPLATE_FILE) $(DEV_PARAMETERS_FILE) Makefile
	aws s3 cp $(ARTIFACT_NAME) s3://$(DEV_ARTIFACTS_BUCKET_NAME)/$(DEV_ARTIFACTS_S3_PREFIX)/$(VERSION)/ --region $(DEV_REGION)

deploy-dev-ci:
	sam deploy --template-file $(TEMPLATE_FILE) --stack-name $(DEV_STACK_NAME) --capabilities $(CAPABILITIES)  --region $(DEV_REGION) --parameter-overrides $(DEV_PARAMETERS)

deploy-dev: upload-dev
	sam deploy --template-file $(TEMPLATE_FILE) --stack-name $(DEV_STACK_NAME) --capabilities $(CAPABILITIES)  --region $(DEV_REGION) --parameter-overrides $(DEV_PARAMETERS)



