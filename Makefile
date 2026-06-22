.PHONY: all init plan apply destroy validate fmt output local-up local-down clean full-deploy

TF_CMD = terraform

all: validate

init:
	$(TF_CMD) init

plan:
	$(TF_CMD) plan

apply:
	$(TF_CMD) apply -auto-approve

destroy:
	$(TF_CMD) destroy -auto-approve

validate:
	$(TF_CMD) validate

fmt:
	$(TF_CMD) fmt

output:
	$(TF_CMD) output

local-up:
	docker compose up -d --wait

local-down:
	docker compose down

clean: destroy
	rm -rf .terraform terraform.tfstate*

full-deploy: local-up init apply output
