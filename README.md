# patientping-infra

Terraform configs for a PatientPing web app running on AWS.

## What's inside

VPC with public/private subnets, an EC2 instance, an RDS Postgres database, security groups, and a NAT gateway for private subnet internet access.

## Local dev

```
docker compose up -d --wait
make init
make apply
make output
```

Needs Ministack running on localhost:4566 (see docker-compose.yml).

## Real AWS

```
cp terraform.tfvars.example terraform.tfvars
# set is_local = false, add db_password
make apply
```

NAT Gateway + RDS cost ~$40/month. Destroy with `make destroy` when done.

## Files

```
providers.tf       — AWS provider + Ministack endpoints
vpc.tf             — VPC, subnets, internet gateway
routing.tf         — route tables, NAT gateway
compute.tf         — EC2, security groups, key pair
database.tf        — RDS Postgres
variables.tf       — configurable values
outputs.tf         — resource outputs
docker-compose.yml — local AWS mock
Makefile           — common commands
```
