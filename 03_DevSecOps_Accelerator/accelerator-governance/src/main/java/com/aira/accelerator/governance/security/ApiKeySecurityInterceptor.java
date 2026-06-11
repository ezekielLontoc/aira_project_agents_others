package com.aira.accelerator.governance.security;

import java.io.IOException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class ApiKeySecurityInterceptor implements HandlerInterceptor {

    private final ApiKeySecurityService apiKeySecurityService;

    public ApiKeySecurityInterceptor(ApiKeySecurityService apiKeySecurityService) {
        this.apiKeySecurityService = apiKeySecurityService;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws IOException {
        String path = request.getRequestURI();
        String method = request.getMethod();

        if ("OPTIONS".equalsIgnoreCase(method)) {
            return true;
        }

        if (isPublic(path)) {
            return true;
        }

        String apiKey = request.getHeader("X-AIRA-API-Key");
        ApiSecurityDecision decision = apiKeySecurityService.validate(apiKey, path, method);

        if (decision.allowed()) {
            return true;
        }

        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.getWriter().write(
                "{"
                + "\"status\":\"DENIED\","
                + "\"decision\":\"" + escape(decision.decision()) + "\","
                + "\"reason\":\"" + escape(decision.reason()) + "\","
                + "\"failClosed\":true"
                + "}"
        );

        return false;
    }

    private boolean isPublic(String path) {
        return path.equals("/api/health")
                || path.equals("/api/v1/security/health")
                || path.equals("/api/persistence/health")
                || path.startsWith("/actuator")
                || path.equals("/")
                || path.startsWith("/error");
    }

    private String escape(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}