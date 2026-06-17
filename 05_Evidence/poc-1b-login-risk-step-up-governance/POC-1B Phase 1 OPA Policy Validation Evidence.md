# POC-1B Phase 1 OPA Policy Validation Evidence

## Status

Created for Phase 1.

## Policy Files

- 03_DevSecOps_Accelerator/policies/identity/poc1b-login-risk-step-up.rego
- 03_DevSecOps_Accelerator/policies/identity/poc1b-login-risk-step-up_test.rego

## Policy Behaviors Covered

- Low-risk login may be allowed.
- Medium/high-risk login requires step-up.
- Repeated failed attempts can lock account.
- Critical risk can lock account.
- Locked account produces deny reason.

## Phase 1 Validation

The Phase 1 validation script checks that policy files exist and include the expected policy rules and test cases.

If the local OPA binary is available, the validation script also attempts to run `opa test`.