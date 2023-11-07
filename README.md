# N3uron & balena demo on AWS

## Prerequisites

* Terraform installed in your machine
* Amazon Web Services account enabled
* An existing EC2 KeyPair in the desired region

## Usage

Initialize Terraform

```shell
terraform init
```

Deploy the infrastructure to your AWS account

```shell
terraform apply -var="key_name=<your-kp-name>"
```
