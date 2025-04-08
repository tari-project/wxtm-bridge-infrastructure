# WXTM-Bridge infrastructure

# Connecting to `wxtm-bridge-dev` database via Bastion

Before connecting, make sure you have the `id_rsa` and `id_rsa.pub` keys on your local machine, and configure SSO profile `tari-dev-sso`.

1. Login using SSO

```
  aws sso login --profile tari-dev-sso
  aws sts get-caller-identity --profile tari-dev-sso

```

2. Connect to EC2 (Bastion)

```
bash scripts/connect-bastion
```

2. Connect to database

```
psql -h wxtm-bridge-dev-wxtmbridgedatabase-1gu-rdspostgres-fnfji43uje4c.cilkkm8qovu8.us-east-1.rds.amazonaws.com -U root wxtmBridgeDev

```

The password can be retrieved from the AWS console (Secrets Manager) or with aws cli

```
aws secretsmanager get-secret-value --secret-id /wxtm-bridge/development/rds-secrets --profile tari-dev-sso | jq -r ".SecretString" | jq

```
