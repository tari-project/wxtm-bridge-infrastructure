DEV_PARAMETERS_FILE=template-config-proposer.dev.json
DEV_PARAMETERS=$(shell cat $(DEV_PARAMETERS_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
DEV_REGION=eu-north-1
DEV_ARTIFACTS_BUCKET_NAME=artifacts.wxtm-bridge
DEV_ARTIFACTS_S3_PREFIX=dev/infrastructure
DEV_STACK_NAME=wxtm-bridge-processor-dev

TEMPLATE_FILE=processor.yml
CAPABILITIES=CAPABILITY_IAM CAPABILITY_AUTO_EXPAND


deploy-dev-base:
	sam deploy --template-file base_setup.yml --stack-name $(DEV_STACK_NAME) --capabilities $(CAPABILITIES)  --region $(DEV_REGION) --parameter-overrides $(DEV_PARAMETERS)

deploy-dev-processor:
	sam deploy --template-file processor.yml --stack-name $(DEV_STACK_NAME)-proposer --capabilities $(CAPABILITIES)  --region $(DEV_REGION) --parameter-overrides $(DEV_PARAMETERS)
