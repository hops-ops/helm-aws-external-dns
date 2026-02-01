# Tests

## Unit Tests (test-render)

Validates composition logic without deploying resources.

```bash
make render   # Run composition render tests
make test     # Run all unit tests
```

## E2E Tests (e2etest-externaldns)

Full integration test that deploys real AWS infrastructure:
1. Creates AutoEKSCluster
2. Deploys helm.aws ExternalDNS (external-dns + AWS Pod Identity)

### Prerequisites

1. Create `tests/e2etest-externaldns/secrets/aws-creds` with AWS credentials:
   ```ini
   [default]
   aws_access_key_id = AKIA...
   aws_secret_access_key = ...
   ```

2. Ensure persistent hops-test network exists

### Running E2E Tests

```bash
make e2e      # Run full e2e test (~90 min for EKS creation)
```

**Note**: E2E tests create real AWS resources and can take up to 90 minutes to complete.
