# helm-aws-external-dns

Installs external-dns with AWS Pod Identity for Route53 DNS record management.

## Overview

Composes the base `helm.hops.ops.com.ai/ExternalDNS` XRD with `aws.hops.ops.com.ai/PodIdentity`.
Automatically provisions IAM role and Pod Identity association for external-dns's service account.

## Usage

```yaml
apiVersion: helm.aws.hops.ops.com.ai/v1alpha1
kind: ExternalDNS
metadata:
  name: external-dns
  namespace: default
spec:
  clusterName: my-cluster
  aws:
    region: us-east-1
```

With custom values:

```yaml
apiVersion: helm.aws.hops.ops.com.ai/v1alpha1
kind: ExternalDNS
metadata:
  name: external-dns
  namespace: default
spec:
  clusterName: production-cluster
  namespace: external-dns
  values:
    policy: sync
    sources:
      - service
      - ingress
      - istio-virtualservice
  aws:
    region: us-west-2
    rolePrefix: prod-
```

## What Gets Created

1. `helm.hops.ops.com.ai/ExternalDNS` - the base external-dns Helm release
2. `aws.hops.ops.com.ai/PodIdentity` - IAM role + Pod Identity association with Route53 permissions

## Development

```bash
make render
make validate
make test
```
