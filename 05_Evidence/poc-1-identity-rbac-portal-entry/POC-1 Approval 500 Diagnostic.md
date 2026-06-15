# POC-1 Approval 500 Diagnostic

## Status

FAILED AS EXPECTED - DIAGNOSTIC CAPTURED

## Date

2026-06-15 17:11:30 +08:00

## Runtime

- Security runtime: http://192.168.179.193:9091
- Security container: aira-accelerator-security
- Security container ID: 452a80ed4a69
- PostgreSQL container: aira-postgres17

## Diagnostic Identity

- Email: poc1.approval.diagnostic.20260615171126@aira.local
- Access request ID: fd9b5a72-321e-40c2-aa3d-f6ed48eb8e20

## Readiness HTTP

- Status code: 200

`json
{"readinessKey":"AIRA-POC1-PHASE2-IDENTITY-CORE-APIS","microfunctions":58,"permissions":10,"status":"UP","identityCoreApiReady":true,"failClosed":true,"timestamp":"2026-06-15T09:11:27.762013656Z","rolePermissions":37,"phase":"POC-1 Build Phase 2"}
`",
",


- Status code: 200

`json
{"status":"PENDING_EMAIL_VERIFICATION","message":"If this request is eligible, verification instructions will be sent.","nextStep":"VERIFY_EMAIL","localOnlyVerificationToken":"vHR8ZSnhdWpGd7mnCBETfBCqp3veALeHkduHf3RW_nw"}
`",
",


- Status code: 200

`json
{"message":"Email verified. Access is now pending institution approval.","nextStep":"PENDING_INSTITUTION_APPROVAL","status":"VERIFIED"}
`",
",


- Status code: 200

`json
[{"access_request_id":"fd9b5a72-321e-40c2-aa3d-f6ed48eb8e20","identity_id":"46d3de54-455c-4006-a3c7-61ee07972264","normalized_email":"poc1.approval.diagnostic.20260615171126@aira.local","display_name":"POC1 ApprovalDiagnosticUser","requested_role":"DEVELOPER","request_status":"PENDING_INSTITUTION_APPROVAL","created_at":"2026-06-15T09:11:28.009+00:00"},{"access_request_id":"62d3f176-18b7-4451-a3c5-697ad9699950","identity_id":"3584ef36-8a00-4e58-9559-a3c5db9e47cc","normalized_email":"poc1.runtime.approval.20260615170558@aira.local","display_name":"POC1 ApprovalRepairUser","requested_role":"DEVELOPER","request_status":"PENDING_INSTITUTION_APPROVAL","created_at":"2026-06-15T09:06:23.515+00:00"},{"access_request_id":"1195768b-d383-4ccf-b322-416afd2164a6","identity_id":"e8c5435d-bdad-4ec0-bf84-ff37d57f8246","normalized_email":"poc1.runtime.repair.20260615170157@aira.local","display_name":"POC1 RuntimeRepairUser","requested_role":"DEVELOPER","request_status":"PENDING_INSTITUTION_APPROVAL","created_at":"2026-06-15T09:02:21.746+00:00"}]
`",
",


- Status code: 500
- Error: The remote server returned an error: (500) Internal Server Error.

`json
{"timestamp":"2026-06-15T09:11:28.829+00:00","status":500,"error":"Internal Server Error","path":"/api/v1/identity/admin/access-requests/fd9b5a72-321e-40c2-aa3d-f6ed48eb8e20/approve"}
`",
",


`	ext
identity_id|institution_id|normalized_email|identity_status|email_verified|institution_approved|requested_role
46d3de54-455c-4006-a3c7-61ee07972264|437bf35b-de9d-47a7-8930-50e04509de43|poc1.approval.diagnostic.20260615171126@aira.local|PENDING_INSTITUTION_APPROVAL|t|f|DEVELOPER
(1 row)
`",
",


`	ext
access_request_id|identity_id|requested_institution_key|requested_institution_id|requested_role|request_status|approval_decision|reviewed_at
fd9b5a72-321e-40c2-aa3d-f6ed48eb8e20|46d3de54-455c-4006-a3c7-61ee07972264|AIRA-DEMO-INSTITUTION|437bf35b-de9d-47a7-8930-50e04509de43|DEVELOPER|PENDING_INSTITUTION_APPROVAL||
(1 row)
`",
",


`	ext
role_assignment_id|identity_id|institution_id|role_key|assignment_status
(0 rows)
`",
",


`	ext
event_type|event_result|denial_reason|created_at
SIGNUP_REQUEST_CREATED|ALLOWED||2026-06-15 09:11:28.009438+00
EMAIL_VERIFICATION_SUCCESS|ALLOWED||2026-06-15 09:11:28.409176+00
(2 rows)
`",
",


`	ext
microfunction_key|execution_status|input_summary|output_summary|failure_reason|created_at
MF-IDENTITY-014|PASSED|Access request moved forward.|Pending institution approval.||2026-06-15 09:11:28.409176+00
MF-IDENTITY-013|PASSED|Email verification token accepted.|Email marked verified.||2026-06-15 09:11:28.409176+00
MF-IDENTITY-004|PASSED|Signup created pending identity.|Identity pending email verification.||2026-06-15 09:11:28.009438+00
MF-IDENTITY-007|PASSED|Verification token generated.|Token hash stored.||2026-06-15 09:11:28.009438+00
MF-IDENTITY-013|PASSED|Email verification token accepted.|Email marked verified.||2026-06-15 09:06:23.939877+00
MF-IDENTITY-014|PASSED|Access request moved forward.|Pending institution approval.||2026-06-15 09:06:23.939877+00
MF-IDENTITY-004|PASSED|Signup created pending identity.|Identity pending email verification.||2026-06-15 09:06:23.515487+00
MF-IDENTITY-007|PASSED|Verification token generated.|Token hash stored.||2026-06-15 09:06:23.515487+00
MF-IDENTITY-014|PASSED|Access request moved forward.|Pending institution approval.||2026-06-15 09:02:22.113967+00
MF-IDENTITY-013|PASSED|Email verification token accepted.|Email marked verified.||2026-06-15 09:02:22.113967+00
MF-IDENTITY-004|PASSED|Signup created pending identity.|Identity pending email verification.||2026-06-15 09:02:21.746995+00
MF-IDENTITY-007|PASSED|Verification token generated.|Token hash stored.||2026-06-15 09:02:21.746995+00
(12 rows)
`",
",


`	ext

`",
",


The approval endpoint still returns HTTP 500. Do not begin Phase 3 until the exact Tomcat stack trace is repaired and the full runtime flow passes.