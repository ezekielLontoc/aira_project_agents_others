package com.aira.accelerator.agents.factory;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ApplicationFactoryController {

    private final ApplicationFactoryService applicationFactoryService;

    public ApplicationFactoryController(ApplicationFactoryService applicationFactoryService) {
        this.applicationFactoryService = applicationFactoryService;
    }

    @GetMapping("/api/v1/application-factory/readiness")
    public Map<String, Object> readiness() {
        return applicationFactoryService.readiness();
    }

    @GetMapping("/api/v1/application-factory/capabilities")
    public List<Map<String, Object>> capabilities() {
        return applicationFactoryService.capabilities();
    }

    @GetMapping("/api/v1/application-factory/templates")
    public List<Map<String, Object>> templates() {
        return applicationFactoryService.templates();
    }

    @GetMapping("/api/v1/application-factory/generators")
    public List<Map<String, Object>> generators() {
        return applicationFactoryService.generators();
    }

    @GetMapping("/api/v1/application-factory/orchestration-steps")
    public List<Map<String, Object>> orchestrationSteps() {
        return applicationFactoryService.orchestrationSteps();
    }

    @GetMapping("/api/v1/application-factory/acceptance-gates")
    public List<Map<String, Object>> acceptanceGates() {
        return applicationFactoryService.acceptanceGates();
    }

    @GetMapping("/api/v1/application-factory/production-profiles")
    public List<Map<String, Object>> productionProfiles() {
        return applicationFactoryService.productionProfiles();
    }

    @GetMapping("/api/v1/application-factory/blueprint-requests")
    public List<Map<String, Object>> blueprintRequests() {
        return applicationFactoryService.blueprintRequests();
    }
}