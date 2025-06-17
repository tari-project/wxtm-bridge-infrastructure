DEV_PARAMETERS_PROPOSER_FILE=template-config-proposer.dev.json
DEV_PARAMETERS_FINALIZER_FILE=template-config-finalizer.dev.json
DEV_PARAMETERS_BASE_SETUP_FILE=template-config-base-setup.dev.json
DEV_PARAMETERS_PROPOSER=$(shell cat $(DEV_PARAMETERS_PROPOSER_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
DEV_PARAMETERS_FINALIZER=$(shell cat $(DEV_PARAMETERS_FINALIZER_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
DEV_PARAMETERS_BASE_SETUP=$(shell cat $(DEV_PARAMETERS_BASE_SETUP_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
DEV_REGION=eu-north-1
DEV_ARTIFACTS_BUCKET_NAME=artifacts.wxtm-bridge
DEV_ARTIFACTS_S3_PREFIX=dev/infrastructure
DEV_STACK_NAME=wxtm-bridge-processor-dev

PROD_PROPOSER_PARAMETERS_BASE_SETUP_FILE=template-config-base-setup.prod-proposer.json
PROD_PROPOSER_PARAMETERS_FILE=template-config-proposer.prod.json
PROD_PROPOSER_PARAMETERS_BASE_SETUP=$(shell cat $(PROD_PROPOSER_PARAMETERS_BASE_SETUP_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
PROD_PROPOSER_PARAMETERS=$(shell cat $(PROD_PROPOSER_PARAMETERS_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
PROD_PROPOSER_REGION=eu-central-1
PROD_PROPOSER_ARTIFACTS_BUCKET_NAME=artifacts.wxtm-bridge-prod-proposer
PROD_PROPOSER_ARTIFACTS_S3_PREFIX=prod/infrastructure
PROD_PROPOSER_STACK_NAME=wxtm-bridge-processor-prod-proposer

PROD_FINALIZER_PARAMETERS_BASE_SETUP_FILE=template-config-base-setup.prod-finalizer.json
PROD_FINALIZER_PARAMETERS_FILE=template-config-finalizer.prod.json
PROD_FINALIZER_PARAMETERS_BASE_SETUP=$(shell cat $(PROD_FINALIZER_PARAMETERS_BASE_SETUP_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
PROD_FINALIZER_PARAMETERS=$(shell cat $(PROD_FINALIZER_PARAMETERS_FILE) | jq -r '.Parameters | to_entries | map("\(.key)=\(.value)") | join(" ")')
PROD_FINALIZER_REGION=eu-central-1
PROD_FINALIZER_ARTIFACTS_BUCKET_NAME=artifacts.wxtm-bridge-prod-finalizer
PROD_FINALIZER_ARTIFACTS_S3_PREFIX=prod/infrastructure
PROD_FINALIZER_STACK_NAME=wxtm-bridge-processor-prod-finalizer

TEMPLATE_FILE=processor.yml
CAPABILITIES=CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND


deploy-dev-base:
	@../scripts/is_correct_aws_account.sh dev
	sam deploy --template-file base_setup.yml --stack-name $(DEV_STACK_NAME) --capabilities $(CAPABILITIES)  --region $(DEV_REGION) --parameter-overrides $(DEV_PARAMETERS_BASE_SETUP)

deploy-prod-proposer-base:
	@../scripts/is_correct_aws_account.sh prod-proposer
	sam deploy --template-file base_setup.yml --stack-name $(PROD_PROPOSER_STACK_NAME) --capabilities $(CAPABILITIES)  --region $(PROD_PROPOSER_REGION) --parameter-overrides $(PROD_PROPOSER_PARAMETERS_BASE_SETUP)

deploy-prod-finalizer-base:
	@../scripts/is_correct_aws_account.sh prod-finalizer
	sam deploy --template-file base_setup.yml --stack-name $(PROD_FINALIZER_STACK_NAME) --capabilities $(CAPABILITIES)  --region $(PROD_FINALIZER_REGION) --parameter-overrides $(PROD_FINALIZER_PARAMETERS_BASE_SETUP)

deploy-dev-proposer:
	@../scripts/is_correct_aws_account.sh dev
	sam deploy --template-file processor.yml --stack-name $(DEV_STACK_NAME)-proposer --capabilities $(CAPABILITIES)  --region $(DEV_REGION) --parameter-overrides $(DEV_PARAMETERS_PROPOSER)

deploy-prod-proposer:
	@../scripts/is_correct_aws_account.sh prod-proposer
	sam deploy --template-file processor.yml --stack-name $(PROD_PROPOSER_STACK_NAME)-processor --capabilities $(CAPABILITIES)  --region $(PROD_PROPOSER_REGION) --parameter-overrides $(PROD_PROPOSER_PARAMETERS)

deploy-prod-proposer-log-export:
	@../scripts/is_correct_aws_account.sh prod-proposer
	sam deploy --template-file log-export.yml --stack-name $(PROD_PROPOSER_STACK_NAME)-log-export --capabilities $(CAPABILITIES)  --region $(PROD_PROPOSER_REGION) --parameter-overrides LogsExportBucketName=log-export.proposer.bridge.tari.com


deploy-dev-finalizer:
	@../scripts/is_correct_aws_account.sh dev
	sam deploy --template-file processor.yml --stack-name $(DEV_STACK_NAME)-finalizer --capabilities $(CAPABILITIES)  --region $(DEV_REGION) --parameter-overrides $(DEV_PARAMETERS_FINALIZER)

deploy-prod-finalizer:
	@../scripts/is_correct_aws_account.sh prod-finalizer
	sam deploy --template-file processor.yml --stack-name $(PROD_FINALIZER_STACK_NAME)-processor --capabilities $(CAPABILITIES)  --region $(PROD_FINALIZER_REGION) --parameter-overrides $(PROD_FINALIZER_PARAMETERS)
