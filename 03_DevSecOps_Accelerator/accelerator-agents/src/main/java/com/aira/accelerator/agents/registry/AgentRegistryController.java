package com.aira.accelerator.agents.registry;

import java.time.OffsetDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AgentRegistryController {

    private final AgentRegistryService agentRegistryService;

    public AgentRegistryController(AgentRegistryService agentRegistryService) {
        this.agentRegistryService = agentRegistryService;
    }

    @GetMapping("/api/v1/agents")
    public ResponseEntity<?> listAgents() {
        return ResponseEntity.ok(agentRegistryService.listAgents());
    }

    @GetMapping("/api/v1/agents/{agentName}")
    public ResponseEntity<?> getAgent(@PathVariable String agentName) {
        return ResponseEntity.ok(agentRegistryService.getAgent(agentName));
    }

    @GetMapping("/api/v1/agents/{agentName}/prompts")
    public ResponseEntity<?> getPromptVersions(@PathVariable String agentName) {
        return ResponseEntity.ok(agentRegistryService.getPromptVersions(agentName));
    }

    @GetMapping("/api/v1/agents/{agentName}/models")
    public ResponseEntity<?> getModelVersions(@PathVariable String agentName) {
        return ResponseEntity.ok(agentRegistryService.getModelVersions(agentName));
    }

    @GetMapping("/api/v1/agents/{agentName}/tools")
    public ResponseEntity<?> getToolPermissions(@PathVariable String agentName) {
        return ResponseEntity.ok(agentRegistryService.getToolPermissions(agentName));
    }

    @GetMapping("/api/v1/agents/governance/summary")
    public ResponseEntity<AgentRegistrySummaryResponse> summary() {
        AgentRegistrySummaryResponse response = agentRegistryService.summary();

        if ("UP".equals(response.status())) {
            return ResponseEntity.ok(response);
        }

        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }

    @ExceptionHandler(AgentRegistryNotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNotFound(AgentRegistryNotFoundException exception) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("status", "NOT_FOUND");
        body.put("message", exception.getMessage());
        body.put("timestamp", OffsetDateTime.now());
        body.put("failClosed", true);

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(body);
    }
}