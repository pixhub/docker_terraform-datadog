FROM golang:1.16.3-buster AS builder

LABEL maintainer="pixhub@github.com"

ENV DD_TF_PLUGIN_VERSION=2.25.0 \
    TF_VERSION=0.15.1

RUN go get golang.org/x/tools/cmd/goimports \
    && go get github.com/hashicorp/go-plugin@v1.3.0 \
    && wget https://github.com/DataDog/terraform-provider-datadog/archive/refs/tags/v${DD_TF_PLUGIN_VERSION}.tar.gz \
    && tar xzvf v${DD_TF_PLUGIN_VERSION}.tar.gz \
    && cd terraform-provider-datadog-${DD_TF_PLUGIN_VERSION} \
    && make build \
    && cd .. \
    && rm -rf *${DD_TF_PLUGIN_VERSION}* \
    && wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && apt-get update \
    && apt-get install -y zip \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip

FROM ubuntu:18.04

ENV DD_TF_PLUGIN_VERSION=2.25.0 \
    TF_VERSION=0.15.1

RUN mkdir -p /root/.terraform.d/plugins/registry.terraform.io/datadog/datadog/${DD_TF_PLUGIN_VERSION}/linux_amd64 \
    && apt-get update \
    && apt-get install -y ca-certificates \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/terraform-provider-datadog /root/.terraform.d/plugins/registry.terraform.io/datadog/datadog/${DD_TF_PLUGIN_VERSION}/linux_amd64/terraform-provider-datadog
COPY --from=builder /go/terraform /usr/local/bin/terraform

WORKDIR /app

CMD ["terraform", "version"]
