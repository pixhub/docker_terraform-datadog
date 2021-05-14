# Terraform Datadog

Terraform is an IAC tool used to provide infrastructure. It uses HCL language to perform provisionning Tasks.
We use it to accelerate Datadog Dashboard and alerting deployement and version it on Gitlab. The deployement is made through the Gitlab-CI and is performed by a Docker image regrouping Terraform and the Datadog Plugin.

## Requirements

> [Terraform](https://terraform.io) 0.15.1

> [terraform-provider-datadog](https://github.com/DataDog/terraform-provider-datadog) 2.25.0

## Environment variables

| **Variable** | **Description** |
|--------------|-----------------|
| TF_VAR_DD_API_KEY | The Datadog API Key |
| TF_VAR_DD_APP_KEY | The Datadog Application Key |

## Build

```
$ docker build -t terraform:0.15.1-2.25.0-datadog
```

## Run

```
# Mount the current Terraform Directory into the container. You can also use automatic push to AWS S3 the tfstate file through Terraform.

$ docker run --rm -e TF_VAR_DD_API_KEY=${DD_API_KEY} \
                  -e TF_VAR_DD_APP_KEY=${DD_APP_KEY} \
                  -v $(pwd):/app \
                  terraform apply -auto-approve
```