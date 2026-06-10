package com.aira.accelerator.api.controller;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import com.aira.accelerator.api.dto.AgentRequest;
import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AgentRequestController {

    @PostMapping("/api/agents/request")
    public Map<String, Object> submitAgentRequest(@Valid @RequestBody AgentRequest request) {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("taskId", request.getTaskId());
        response.put("agentName", request.getAgentName());
        response.put("status", "ACCEPTED_PLACEHOLDER");
        response.put("productionActionBlocked", true);
        response.put("message", "Agent request received. Execution engine not yet enabled.");
        response.put("timestamp", Instant.now().toString());
        return response;
    }
}
