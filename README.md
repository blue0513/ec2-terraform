# EC2 Terraform

[![CI](https://github.com/blue0513/ec2-terraform/actions/workflows/ci.yml/badge.svg)](https://github.com/blue0513/ec2-terraform/actions/workflows/ci.yml)

This repository can assist you in quickly creating EC2 instances.

## Quick Start

```console
# Configuring terraform & ssh-key
$ make prepare

# Creating EC2 instances with VPC
$ make plan
$ make apply

# Removing EC2 instances with VPC
$ make destroy
```
