# POC-1B MicroFunction Catalog

Range: MF-LOGIN-RISK-001 through MF-LOGIN-RISK-040

| Key | Name | Purpose |
|---|---|---|
| MF-LOGIN-RISK-001 | Capture login attempt | Record every login attempt with identity, institution, device, IP, user agent, and result context. |
| MF-LOGIN-RISK-002 | Classify login failure | Classify failed login attempts into actionable failure categories. |
| MF-LOGIN-RISK-003 | Detect repeated failed attempts | Detect repeated failures inside the configured policy window. |
| MF-LOGIN-RISK-004 | Detect unknown device | Detect whether a login came from a new or unusual device signal. |
| MF-LOGIN-RISK-005 | Detect institution mismatch | Detect login attempt mismatch between identity and institution. |
| MF-LOGIN-RISK-006 | Calculate login risk score | Calculate risk score using failure, device, institution, role, and policy factors. |
| MF-LOGIN-RISK-007 | Persist login risk event | Store login risk event for review and evidence. |
| MF-LOGIN-RISK-008 | Trigger suspicious login review | Place suspicious login event into security review queue. |
| MF-LOGIN-RISK-009 | Create login incident record | Create incident record when policy or risk threshold is reached. |
| MF-LOGIN-RISK-010 | Generate incident summary | Generate human-readable incident analysis. |
| MF-LOGIN-RISK-011 | Recommend triage action | Recommend allow, deny, step-up, lock, or review action. |
| MF-LOGIN-RISK-012 | Lock account | Lock identity after policy threshold or human decision. |
| MF-LOGIN-RISK-013 | Create unlock request | Create governed unlock request for locked account. |
| MF-LOGIN-RISK-014 | Route unlock request to approval | Route unlock request through approval workflow. |
| MF-LOGIN-RISK-015 | Approve unlock request | Approve unlock request after human review. |
| MF-LOGIN-RISK-016 | Reject unlock request | Reject unlock request and keep account locked. |
| MF-LOGIN-RISK-017 | Unlock account | Unlock account after approved request. |
| MF-LOGIN-RISK-018 | Audit lock decision | Record audit evidence for account lock. |
| MF-LOGIN-RISK-019 | Audit unlock decision | Record audit evidence for account unlock. |
| MF-LOGIN-RISK-020 | Evaluate step-up policy | Determine whether login requires step-up authentication. |
| MF-LOGIN-RISK-021 | Create step-up challenge | Create step-up challenge for the login attempt. |
| MF-LOGIN-RISK-022 | Validate step-up challenge | Validate submitted step-up challenge. |
| MF-LOGIN-RISK-023 | Expire step-up challenge | Expire stale or exceeded step-up challenge. |
| MF-LOGIN-RISK-024 | Deny login after failed step-up | Deny login when step-up challenge fails. |
| MF-LOGIN-RISK-025 | Allow login after successful step-up | Allow login after successful step-up challenge. |
| MF-LOGIN-RISK-026 | Apply OPA login policy | Evaluate OPA policy for login decision. |
| MF-LOGIN-RISK-027 | Apply OPA account lock policy | Evaluate OPA policy for account lock decision. |
| MF-LOGIN-RISK-028 | Apply OPA step-up policy | Evaluate OPA policy for step-up decision. |
| MF-LOGIN-RISK-029 | Record policy decision | Persist policy decision output. |
| MF-LOGIN-RISK-030 | Record policy evidence | Persist policy input, output, and evidence context. |
| MF-LOGIN-RISK-031 | Notify security officer | Create notification for security officer review. |
| MF-LOGIN-RISK-032 | Notify institution admin | Create notification for institution admin review. |
| MF-LOGIN-RISK-033 | Query suspicious login queue | Read suspicious login queue for portal dashboard. |
| MF-LOGIN-RISK-034 | Query locked accounts | Read locked accounts for review. |
| MF-LOGIN-RISK-035 | Query login incident history | Read incident history for review and evidence. |
| MF-LOGIN-RISK-036 | Export login risk evidence | Export login risk evidence for evidence pack. |
| MF-LOGIN-RISK-037 | Reconcile risk event state | Reconcile event state with lock, incident, and approval records. |
| MF-LOGIN-RISK-038 | Validate approval workflow state | Validate unlock workflow state transitions. |
| MF-LOGIN-RISK-039 | Run login risk readiness check | Expose runtime readiness status for POC-1B login risk capability. |
| MF-LOGIN-RISK-040 | Run login risk simulation check | Run simulation check for login risk flows. |