#!/bin/bash

ACCOUNT_NAME=${1}
DESIRED_ACCOUNT_ID=""
# map desired account id to the name of the account
if [ "$ACCOUNT_NAME" = "dev" ]; then
  DESIRED_ACCOUNT_ID="848802075970"
elif [ "$ACCOUNT_NAME" = "prod-backend" ]; then
  DESIRED_ACCOUNT_ID="090733632832"
elif [ "$ACCOUNT_NAME" = "prod-finalizer" ]; then
  DESIRED_ACCOUNT_ID="796586191783"
elif [ "$ACCOUNT_NAME" = "prod-proposer" ]; then
  DESIRED_ACCOUNT_ID="695926189147"
else
  echo "Error: Unknown account name: $ACCOUNT_NAME. Use one of the following: dev, prod-backend, prod-finalizer, prod-proposer";
  exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
if [ "$ACCOUNT_ID" != "$DESIRED_ACCOUNT_ID" ]; then
  echo "Error: Deployment must be done from AWS account $DESIRED_ACCOUNT_ID. Current account: $ACCOUNT_ID"; \
  exit 1;
fi