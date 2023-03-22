# Makefile

.PHONY: prepare plan apply ssh destroy fmt

PUBLIC_IP := $(shell cat terraform/terraform.tfstate | grep '"public_ip":' | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

prepare:
	ssh-keygen -t rsa -b 4096 -m PEM -f ./ssh-keys/my-ssh-key
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply --auto-approve

ssh:
	ssh -i ssh-keys/my-ssh-key ubuntu@$(PUBLIC_IP)

destroy:
	cd terraform &&terraform destroy --auto-approve

fmt:
	cd terraform && terraform fmt -recursive
