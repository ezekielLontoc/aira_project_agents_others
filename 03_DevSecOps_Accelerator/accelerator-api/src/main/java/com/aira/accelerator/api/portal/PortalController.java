package com.aira.accelerator.api.portal;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.view.RedirectView;

@RestController
public class PortalController {

    private final PortalReadinessService portalReadinessService;

    public PortalController(PortalReadinessService portalReadinessService) {
        this.portalReadinessService = portalReadinessService;
    }

    @GetMapping("/")
    public RedirectView root() {
        return new RedirectView("/portal/index.html");
    }

    @GetMapping("/portal")
    public RedirectView portal() {
        return new RedirectView("/portal/index.html");
    }

    @GetMapping("/api/v1/portal/readiness")
    public ResponseEntity<PortalReadinessResponse> readiness() {
        PortalReadinessResponse response = portalReadinessService.readiness();

        if ("UP".equals(response.status())) {
            return ResponseEntity.ok(response);
        }

        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
}