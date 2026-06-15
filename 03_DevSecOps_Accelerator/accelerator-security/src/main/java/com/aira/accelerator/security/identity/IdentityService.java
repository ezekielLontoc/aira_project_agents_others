package com.aira.accelerator.security.identity;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class IdentityService {
    private static final String LOCAL_ADMIN_KEY = "aira-local-dev-key-change-me";

    private final JdbcTemplate jdbcTemplate;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder(12);

    public IdentityService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Map<String, Object> readiness() {
        int permissions = count("select count(*) from aira_security.identity_permission_catalog");
        int rolePermissions = count("select count(*) from aira_security.identity_role_permission");
        int microfunctions = count("select count(*) from aira_security.identity_microfunction_catalog");
        return IdentityModels.readiness(permissions, rolePermissions, microfunctions);
    }

    public List<Map<String, Object>> microfunctions() {
        return jdbcTemplate.queryForList(
            "select microfunction_key, microfunction_name, microfunction_category, execution_phase, fail_closed_required, audit_required, evidence_required, microfunction_status " +
            "from aira_security.identity_microfunction_catalog order by microfunction_key"
        );
    }

    @Transactional
    public Map<String, Object> signup(Map<String, Object> request) {
        String firstName = IdentitySecurityUtil.safeString(request.get("firstName"));
        String lastName = IdentitySecurityUtil.safeString(request.get("lastName"));
        String email = IdentitySecurityUtil.normalizeEmail(IdentitySecurityUtil.safeString(request.get("email")));
        String institutionKey = IdentitySecurityUtil.safeString(request.get("institutionKey"));
        String requestedRole = IdentitySecurityUtil.safeString(request.get("requestedRole"));
        String password = IdentitySecurityUtil.safeString(request.get("password"));
        String confirmPassword = IdentitySecurityUtil.safeString(request.get("confirmPassword"));
        String department = IdentitySecurityUtil.safeString(request.get("department"));
        String jobTitle = IdentitySecurityUtil.safeString(request.get("jobTitle"));
        String requestReason = IdentitySecurityUtil.safeString(request.get("requestReason"));
        boolean acceptedGovernance = IdentitySecurityUtil.safeBoolean(request.get("acceptGovernancePolicy"));
        boolean acceptedTerms = IdentitySecurityUtil.safeBoolean(request.get("acceptTermsOfUse"));

        if (firstName.isBlank() || lastName.isBlank() || email.isBlank() || password.isBlank()) {
            return IdentityModels.denied("Signup request is incomplete.");
        }

        if (!password.equals(confirmPassword)) {
            return IdentityModels.denied("Signup request is incomplete.");
        }

        if (!acceptedGovernance || !acceptedTerms) {
            return IdentityModels.denied("Governance policy and terms must be accepted.");
        }

        if (requestedRole.isBlank()) {
            requestedRole = "VIEWER";
        }

        UUID institutionId = resolveInstitutionId(institutionKey, email);

        if (institutionId == null) {
            auditLogin(null, null, email, "SIGNUP_DENIED", "DENIED", "INSTITUTION_NOT_FOUND");
            return IdentityModels.denied("Access request could not be accepted.");
        }

        if (identityExists(email)) {
            auditLogin(null, institutionId, email, "SIGNUP_ALREADY_EXISTS", "DENIED", "IDENTITY_ALREADY_EXISTS");

            return Map.of(
                "status", "PENDING_EMAIL_VERIFICATION",
                "message", "If this request is eligible, verification instructions will be sent.",
                "nextStep", "VERIFY_EMAIL"
            );
        }

        UUID identityId = UUID.randomUUID();
        UUID accessRequestId = UUID.randomUUID();

        String displayName = (firstName + " " + lastName).trim();
        String passwordHash = passwordEncoder.encode(password);
        String verificationToken = IdentitySecurityUtil.randomToken();
        String verificationHash = IdentitySecurityUtil.sha256(verificationToken);

        jdbcTemplate.update(
            "insert into aira_security.platform_identity " +
            "(identity_id, institution_id, email, normalized_email, first_name, last_name, display_name, department, job_title, requested_role, identity_status, email_verified, institution_approved, governance_terms_accepted) " +
            "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING_EMAIL_VERIFICATION', false, false, true)",
            identityId,
            institutionId,
            email,
            email,
            firstName,
            lastName,
            displayName,
            blankToNull(department),
            blankToNull(jobTitle),
            requestedRole
        );

        jdbcTemplate.update(
            "insert into aira_security.platform_identity_credential " +
            "(identity_id, credential_type, password_hash, password_algorithm, password_status, password_changed_at) " +
            "values (?, 'PASSWORD', ?, 'BCRYPT', 'ACTIVE', now())",
            identityId,
            passwordHash
        );

        jdbcTemplate.update(
            "insert into aira_security.identity_access_request " +
            "(access_request_id, identity_id, requested_institution_key, requested_institution_id, requested_role, request_reason, request_status) " +
            "values (?, ?, ?, ?, ?, ?, 'PENDING_EMAIL_VERIFICATION')",
            accessRequestId,
            identityId,
            institutionKey,
            institutionId,
            requestedRole,
            blankToNull(requestReason)
        );

        jdbcTemplate.update(
            "insert into aira_security.identity_email_verification " +
            "(identity_id, token_hash, verification_status, verification_channel, sent_to_email, expires_at) " +
            "values (?, ?, 'PENDING', 'EMAIL', ?, now() + interval '24 hours')",
            identityId,
            verificationHash,
            email
        );

        jdbcTemplate.update(
            "insert into aira_security.identity_notification_outbox " +
            "(identity_id, institution_id, notification_type, recipient_email, subject, body_template_key, safe_message_summary, notification_status) " +
            "values (?, ?, 'VERIFY_EMAIL', ?, 'Verify your AIRA account email', 'POC1_VERIFY_EMAIL', 'Verification email queued for POC-1 local validation.', 'QUEUED')",
            identityId,
            institutionId,
            email
        );

        auditLogin(identityId, institutionId, email, "SIGNUP_REQUEST_CREATED", "ALLOWED", null);
        recordMicrofunction("MF-IDENTITY-004", identityId, institutionId, accessRequestId, null, "PASSED", "Signup created pending identity.", "Identity pending email verification.", null);
        recordMicrofunction("MF-IDENTITY-007", identityId, institutionId, accessRequestId, null, "PASSED", "Verification token generated.", "Token hash stored.", null);

        return Map.of(
            "status", "PENDING_EMAIL_VERIFICATION",
            "message", "If this request is eligible, verification instructions will be sent.",
            "nextStep", "VERIFY_EMAIL",
            "localOnlyVerificationToken", verificationToken
        );
    }

    @Transactional
    public Map<String, Object> verifyEmail(Map<String, Object> request) {
        String token = IdentitySecurityUtil.safeString(request.get("token"));

        if (token.isBlank()) {
            return IdentityModels.denied("Verification token is required.");
        }

        String tokenHash = IdentitySecurityUtil.sha256(token);

        Map<String, Object> verification;

        try {
            verification = jdbcTemplate.queryForMap(
                "select v.verification_id, v.identity_id, i.institution_id, i.normalized_email " +
                "from aira_security.identity_email_verification v " +
                "join aira_security.platform_identity i on i.identity_id = v.identity_id " +
                "where v.token_hash = ? and v.verification_status = 'PENDING' and v.expires_at > now()",
                tokenHash
            );
        } catch (EmptyResultDataAccessException ex) {
            auditLogin(null, null, null, "EMAIL_VERIFICATION_DENIED", "DENIED", "INVALID_OR_EXPIRED_TOKEN");
            return IdentityModels.denied("Verification token is invalid or expired.");
        }

        UUID verificationId = (UUID) verification.get("verification_id");
        UUID identityId = (UUID) verification.get("identity_id");
        UUID institutionId = (UUID) verification.get("institution_id");
        String email = String.valueOf(verification.get("normalized_email"));

        jdbcTemplate.update(
            "update aira_security.identity_email_verification set verification_status = 'USED', used_at = now() where verification_id = ?",
            verificationId
        );

        jdbcTemplate.update(
            "update aira_security.platform_identity set email_verified = true, identity_status = 'PENDING_INSTITUTION_APPROVAL', updated_at = now() where identity_id = ?",
            identityId
        );

        jdbcTemplate.update(
            "update aira_security.identity_access_request set request_status = 'PENDING_INSTITUTION_APPROVAL', email_verified_at = now(), updated_at = now() where identity_id = ? and request_status = 'PENDING_EMAIL_VERIFICATION'",
            identityId
        );

        jdbcTemplate.update(
            "insert into aira_security.identity_notification_outbox " +
            "(identity_id, institution_id, notification_type, recipient_email, subject, body_template_key, safe_message_summary, notification_status) " +
            "values (?, ?, 'PENDING_APPROVAL', ?, 'Your AIRA access request is pending institution approval', 'POC1_PENDING_APPROVAL', 'Email verified and request moved to pending institution approval.', 'QUEUED')",
            identityId,
            institutionId,
            email
        );

        auditLogin(identityId, institutionId, email, "EMAIL_VERIFICATION_SUCCESS", "ALLOWED", null);
        recordMicrofunction("MF-IDENTITY-013", identityId, institutionId, null, null, "PASSED", "Email verification token accepted.", "Email marked verified.", null);
        recordMicrofunction("MF-IDENTITY-014", identityId, institutionId, null, null, "PASSED", "Access request moved forward.", "Pending institution approval.", null);

        return Map.of(
            "status", "VERIFIED",
            "message", "Email verified. Access is now pending institution approval.",
            "nextStep", "PENDING_INSTITUTION_APPROVAL"
        );
    }

    @Transactional
    public Map<String, Object> login(Map<String, Object> request) {
        String email = IdentitySecurityUtil.normalizeEmail(IdentitySecurityUtil.safeString(request.get("email")));
        String password = IdentitySecurityUtil.safeString(request.get("password"));
        String institutionKey = IdentitySecurityUtil.safeString(request.get("institutionKey"));

        if (email.isBlank() || password.isBlank()) {
            auditLogin(null, null, email, "LOGIN_FAILURE", "DENIED", "INVALID_CREDENTIALS");
            return IdentityModels.denied("Access denied.");
        }

        Map<String, Object> identity;

        try {
            identity = jdbcTemplate.queryForMap(
                "select i.identity_id, i.institution_id, i.normalized_email, i.display_name, i.identity_status, i.email_verified, i.institution_approved, c.password_hash " +
                "from aira_security.platform_identity i " +
                "join aira_security.platform_identity_credential c on c.identity_id = i.identity_id and c.password_status = 'ACTIVE' " +
                "where i.normalized_email = ?",
                email
            );
        } catch (EmptyResultDataAccessException ex) {
            auditLogin(null, null, email, "LOGIN_FAILURE", "DENIED", "INVALID_CREDENTIALS");
            return IdentityModels.denied("Access denied.");
        }

        UUID identityId = (UUID) identity.get("identity_id");
        UUID institutionId = (UUID) identity.get("institution_id");
        String passwordHash = String.valueOf(identity.get("password_hash"));

        if (!passwordEncoder.matches(password, passwordHash)) {
            jdbcTemplate.update(
                "update aira_security.platform_identity set failed_login_count = failed_login_count + 1, updated_at = now() where identity_id = ?",
                identityId
            );

            auditLogin(identityId, institutionId, email, "LOGIN_FAILURE", "DENIED", "INVALID_CREDENTIALS");
            recordMicrofunction("MF-IDENTITY-037", identityId, institutionId, null, null, "PASSED", "Login failed.", "Failure audited.", "INVALID_CREDENTIALS");
            return IdentityModels.denied("Access denied.");
        }

        String status = String.valueOf(identity.get("identity_status"));
        boolean emailVerified = Boolean.TRUE.equals(identity.get("email_verified"));
        boolean institutionApproved = Boolean.TRUE.equals(identity.get("institution_approved"));

        if (!emailVerified) {
            auditLogin(identityId, institutionId, email, "LOGIN_FAILURE", "DENIED", "EMAIL_NOT_VERIFIED");
            return IdentityModels.denied("Access denied.");
        }

        if (!institutionApproved || !"ACTIVE".equals(status)) {
            auditLogin(identityId, institutionId, email, "LOGIN_FAILURE", "DENIED", "PENDING_APPROVAL");
            return IdentityModels.denied("Access denied.");
        }

        List<String> roles = rolesFor(identityId, institutionId);

        if (roles.isEmpty()) {
            auditLogin(identityId, institutionId, email, "LOGIN_FAILURE", "DENIED", "NO_ROLE_ASSIGNED");
            return IdentityModels.denied("Access denied.");
        }

        if (!institutionKey.isBlank() && !institutionMatches(institutionId, institutionKey)) {
            auditLogin(identityId, institutionId, email, "LOGIN_FAILURE", "DENIED", "INSTITUTION_MISMATCH");
            return IdentityModels.denied("Access denied.");
        }

        String sessionToken = IdentitySecurityUtil.randomToken();
        String sessionHash = IdentitySecurityUtil.sha256(sessionToken);
        UUID sessionId = UUID.randomUUID();

        jdbcTemplate.update(
            "insert into aira_security.identity_session " +
            "(session_id, identity_id, institution_id, session_token_hash, session_status, issued_at, expires_at, last_activity_at) " +
            "values (?, ?, ?, ?, 'ACTIVE', now(), now() + interval '8 hours', now())",
            sessionId,
            identityId,
            institutionId,
            sessionHash
        );

        jdbcTemplate.update(
            "update aira_security.platform_identity set failed_login_count = 0, last_login_at = now(), updated_at = now() where identity_id = ?",
            identityId
        );

        auditLogin(identityId, institutionId, email, "LOGIN_SUCCESS", "ALLOWED", null);
        recordMicrofunction("MF-IDENTITY-035", identityId, institutionId, null, sessionId, "PASSED", "Login accepted.", "Active session created.", null);

        Map<String, Object> context = sessionContext(sessionToken);

        return Map.of(
            "status", "AUTHENTICATED",
            "sessionToken", sessionToken,
            "context", context
        );
    }

    @Transactional
    public Map<String, Object> logout(String token) {
        SessionRecord session = loadSession(token);

        if (session == null) {
            return IdentityModels.denied("Invalid session.");
        }

        jdbcTemplate.update(
            "update aira_security.identity_session set session_status = 'LOGGED_OUT', logout_at = now(), updated_at = now() where session_id = ?",
            session.sessionId()
        );

        auditLogin(session.identityId(), session.institutionId(), session.email(), "LOGOUT", "ALLOWED", null);
        recordMicrofunction("MF-IDENTITY-050", session.identityId(), session.institutionId(), null, session.sessionId(), "PASSED", "Logout requested.", "Session revoked.", null);

        return IdentityModels.response("LOGGED_OUT", "Session has been logged out.");
    }

    public Map<String, Object> sessionContext(String token) {
        SessionRecord session = loadSession(token);

        if (session == null) {
            return IdentityModels.denied("Invalid session.");
        }

        List<String> roles = rolesFor(session.identityId(), session.institutionId());
        List<String> permissions = permissionsFor(roles);
        String route = landingRoute(roles);

        return IdentityModels.sessionContext(
            session.email(),
            session.displayName(),
            session.institutionKey(),
            session.institutionName(),
            roles,
            permissions,
            route,
            session.expiresAt()
        );
    }

    public List<Map<String, Object>> accessRequests(String adminKey) {
        requireLocalAdmin(adminKey);

        return jdbcTemplate.queryForList(
            "select ar.access_request_id, i.identity_id, i.normalized_email, i.display_name, ar.requested_role, ar.request_status, ar.created_at " +
            "from aira_security.identity_access_request ar " +
            "join aira_security.platform_identity i on i.identity_id = ar.identity_id " +
            "order by ar.created_at desc"
        );
    }

    @Transactional
    public Map<String, Object> approveAccessRequest(String adminKey, UUID requestId, Map<String, Object> request) {
        requireLocalAdmin(adminKey);

        String roleKey = IdentitySecurityUtil.safeString(request.get("roleKey"));

        if (roleKey.isBlank()) {
            roleKey = "VIEWER";
        }

        Map<String, Object> accessRequest = jdbcTemplate.queryForMap(
            "select ar.access_request_id, ar.identity_id, ar.requested_institution_id, i.normalized_email " +
            "from aira_security.identity_access_request ar " +
            "join aira_security.platform_identity i on i.identity_id = ar.identity_id " +
            "where ar.access_request_id = ?",
            requestId
        );

        UUID identityId = (UUID) accessRequest.get("identity_id");
        UUID institutionId = (UUID) accessRequest.get("requested_institution_id");
        String email = String.valueOf(accessRequest.get("normalized_email"));

        jdbcTemplate.update(
            "update aira_security.identity_access_request set request_status = 'APPROVED', approval_decision = 'APPROVED', reviewed_at = now(), updated_at = now() where access_request_id = ?",
            requestId
        );

        jdbcTemplate.update(
            "update aira_security.platform_identity set identity_status = 'ACTIVE', institution_approved = true, institution_id = ?, updated_at = now() where identity_id = ?",
            institutionId,
            identityId
        );

        jdbcTemplate.update(
            "insert into aira_security.identity_role_assignment " +
            "(identity_id, institution_id, role_key, assignment_status, assigned_at) " +
            "values (?, ?, ?, 'ACTIVE', now()) " +
            "on conflict (identity_id, institution_id, role_key) do update set assignment_status = 'ACTIVE', updated_at = now()",
            identityId,
            institutionId,
            roleKey
        );

        jdbcTemplate.update(
            "insert into aira_security.identity_notification_outbox " +
            "(identity_id, institution_id, notification_type, recipient_email, subject, body_template_key, safe_message_summary, notification_status) " +
            "values (?, ?, 'ACCESS_APPROVED', ?, 'Your AIRA account is approved', 'POC1_ACCESS_APPROVED', 'Access approved for local POC-1 validation.', 'QUEUED')",
            identityId,
            institutionId,
            email
        );

        auditLogin(identityId, institutionId, email, "ACCESS_REQUEST_APPROVED", "ALLOWED", null);
        recordMicrofunction("MF-IDENTITY-020", identityId, institutionId, requestId, null, "PASSED", "Access request approved.", "Identity activated.", null);
        recordMicrofunction("MF-IDENTITY-022", identityId, institutionId, requestId, null, "PASSED", "Role assigned.", roleKey, null);

        return Map.of(
            "status", "APPROVED",
            "identityId", identityId.toString(),
            "institutionId", institutionId.toString(),
            "roleKey", roleKey
        );
    }

    @Transactional
    public Map<String, Object> rejectAccessRequest(String adminKey, UUID requestId, Map<String, Object> request) {
        requireLocalAdmin(adminKey);

        String reason = IdentitySecurityUtil.safeString(request.get("reason"));

        Map<String, Object> accessRequest = jdbcTemplate.queryForMap(
            "select ar.identity_id, ar.requested_institution_id, i.normalized_email " +
            "from aira_security.identity_access_request ar " +
            "join aira_security.platform_identity i on i.identity_id = ar.identity_id " +
            "where ar.access_request_id = ?",
            requestId
        );

        UUID identityId = (UUID) accessRequest.get("identity_id");
        UUID institutionId = (UUID) accessRequest.get("requested_institution_id");
        String email = String.valueOf(accessRequest.get("normalized_email"));

        jdbcTemplate.update(
            "update aira_security.identity_access_request set request_status = 'REJECTED', approval_decision = 'REJECTED', approval_notes = ?, reviewed_at = now(), updated_at = now() where access_request_id = ?",
            blankToNull(reason),
            requestId
        );

        jdbcTemplate.update(
            "update aira_security.platform_identity set identity_status = 'REJECTED', updated_at = now() where identity_id = ?",
            identityId
        );

        auditLogin(identityId, institutionId, email, "ACCESS_REQUEST_REJECTED", "DENIED", "REQUEST_REJECTED");
        recordMicrofunction("MF-IDENTITY-021", identityId, institutionId, requestId, null, "PASSED", "Access request rejected.", "Identity rejected.", null);

        return Map.of(
            "status", "REJECTED",
            "identityId", identityId.toString()
        );
    }

    private UUID resolveInstitutionId(String institutionKey, String email) {
        if (institutionKey != null && !institutionKey.isBlank()) {
            try {
                return jdbcTemplate.queryForObject(
                    "select institution_id from aira_security.institution where institution_key = ? and institution_status = 'ACTIVE'",
                    UUID.class,
                    institutionKey
                );
            } catch (EmptyResultDataAccessException ignored) {
            }
        }

        String domain = IdentitySecurityUtil.emailDomain(email);

        if (domain.isBlank()) {
            return null;
        }

        try {
            return jdbcTemplate.queryForObject(
                "select institution_id from aira_security.institution_domain where domain_name = ? and domain_status = 'ACTIVE'",
                UUID.class,
                domain
            );
        } catch (EmptyResultDataAccessException ex) {
            return null;
        }
    }

    private boolean identityExists(String normalizedEmail) {
        Integer value = jdbcTemplate.queryForObject(
            "select count(*) from aira_security.platform_identity where normalized_email = ?",
            Integer.class,
            normalizedEmail
        );

        return value != null && value > 0;
    }

    private boolean institutionMatches(UUID institutionId, String institutionKey) {
        Integer value = jdbcTemplate.queryForObject(
            "select count(*) from aira_security.institution where institution_id = ? and institution_key = ?",
            Integer.class,
            institutionId,
            institutionKey
        );

        return value != null && value > 0;
    }

    private SessionRecord loadSession(String token) {
        if (token == null || token.isBlank()) {
            return null;
        }

        String hash = IdentitySecurityUtil.sha256(token);

        try {
            Map<String, Object> row = jdbcTemplate.queryForMap(
                "select s.session_id, s.identity_id, s.institution_id, s.expires_at, i.normalized_email, i.display_name, inst.institution_key, inst.institution_name " +
                "from aira_security.identity_session s " +
                "join aira_security.platform_identity i on i.identity_id = s.identity_id " +
                "join aira_security.institution inst on inst.institution_id = s.institution_id " +
                "where s.session_token_hash = ? and s.session_status = 'ACTIVE' and s.expires_at > now()",
                hash
            );

            UUID sessionId = (UUID) row.get("session_id");
            UUID identityId = (UUID) row.get("identity_id");
            UUID institutionId = (UUID) row.get("institution_id");
            OffsetDateTime expiresAt = (OffsetDateTime) row.get("expires_at");

            jdbcTemplate.update(
                "update aira_security.identity_session set last_activity_at = now(), updated_at = now() where session_id = ?",
                sessionId
            );

            return new SessionRecord(
                sessionId,
                identityId,
                institutionId,
                String.valueOf(row.get("normalized_email")),
                String.valueOf(row.get("display_name")),
                String.valueOf(row.get("institution_key")),
                String.valueOf(row.get("institution_name")),
                expiresAt
            );
        } catch (EmptyResultDataAccessException ex) {
            return null;
        }
    }

    private List<String> rolesFor(UUID identityId, UUID institutionId) {
        return jdbcTemplate.queryForList(
            "select role_key from aira_security.identity_role_assignment where identity_id = ? and institution_id = ? and assignment_status = 'ACTIVE' order by role_key",
            String.class,
            identityId,
            institutionId
        );
    }

    private List<String> permissionsFor(List<String> roles) {
        if (roles == null || roles.isEmpty()) {
            return List.of();
        }

        List<String> permissions = new ArrayList<>();

        for (String role : roles) {
            permissions.addAll(
                jdbcTemplate.queryForList(
                    "select permission_key from aira_security.identity_role_permission where role_key = ? and mapping_status = 'ACTIVE' order by permission_key",
                    String.class,
                    role
                )
            );
        }

        return permissions.stream().distinct().sorted().toList();
    }

    private String landingRoute(List<String> roles) {
        if (roles.contains("PLATFORM_ADMIN")) {
            return "/portal/admin-dashboard.html";
        }

        if (roles.contains("INSTITUTION_ADMIN")) {
            return "/portal/institution-dashboard.html";
        }

        if (roles.contains("SECURITY_OFFICER")) {
            return "/portal/security-dashboard.html";
        }

        if (roles.contains("AUDITOR")) {
            return "/portal/evidence-dashboard.html";
        }

        if (roles.contains("DEVELOPER")) {
            return "/portal/developer-dashboard.html";
        }

        return "/portal/viewer-dashboard.html";
    }

    private int count(String sql) {
        Integer value = jdbcTemplate.queryForObject(sql, Integer.class);
        return value == null ? 0 : value;
    }

    private void auditLogin(UUID identityId, UUID institutionId, String email, String eventType, String result, String denialReason) {
        jdbcTemplate.update(
            "insert into aira_security.identity_login_audit " +
            "(identity_id, institution_id, normalized_email, event_type, event_result, denial_reason, client_ip, user_agent) " +
            "values (?, ?, ?, ?, ?, ?, 'backend-api', 'AIRA-POC1-PHASE2')",
            identityId,
            institutionId,
            email,
            eventType,
            result,
            denialReason
        );
    }

    private void recordMicrofunction(String key, UUID identityId, UUID institutionId, UUID accessRequestId, UUID sessionId, String status, String inputSummary, String outputSummary, String failureReason) {
        jdbcTemplate.update(
            "insert into aira_security.identity_microfunction_execution " +
            "(microfunction_key, identity_id, institution_id, access_request_id, session_id, correlation_id, execution_status, input_summary, output_summary, failure_reason, started_at, completed_at) " +
            "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now())",
            key,
            identityId,
            institutionId,
            accessRequestId,
            sessionId,
            UUID.randomUUID().toString(),
            status,
            inputSummary,
            outputSummary,
            failureReason
        );
    }

    private void requireLocalAdmin(String adminKey) {
        if (!LOCAL_ADMIN_KEY.equals(adminKey)) {
            throw new IllegalArgumentException("Local admin key is invalid.");
        }
    }

    private String blankToNull(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }

        return value;
    }

    private record SessionRecord(
        UUID sessionId,
        UUID identityId,
        UUID institutionId,
        String email,
        String displayName,
        String institutionKey,
        String institutionName,
        OffsetDateTime expiresAt
    ) {
    }
}