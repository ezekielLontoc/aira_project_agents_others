(function () {
  const host = window.location.hostname || "localhost";

  const endpoints = {
    apiHealth: "http://" + host + ":9090/api/health",
    portalReadiness: "http://" + host + ":9090/api/v1/portal/readiness",
    agentSummary: "http://" + host + ":9094/api/v1/agents/governance/summary",
    governanceReadiness: "http://" + host + ":9092/api/v1/governance/readiness",
    evidenceReadiness: "http://" + host + ":9093/api/v1/evidence/readiness",
    evidencePack: "http://" + host + ":9093/api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE",
    evidenceArtifacts: "http://" + host + ":9093/api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE/artifacts",
    releaseReadiness: "http://" + host + ":9092/api/v1/governance/release/readiness"
  };

  const localKeyName = "aira.portal.apiKey." + host;

  function element(id) {
    return document.getElementById(id);
  }

  function log(message) {
    const consoleOutput = element("consoleOutput");
    const time = new Date().toLocaleTimeString();
    consoleOutput.textContent += "\n[" + time + "] " + message;
    consoleOutput.scrollTop = consoleOutput.scrollHeight;
  }

  function setMetric(metricId, detailsId, status, details) {
    const metric = element(metricId);
    const detailsElement = element(detailsId);
    metric.textContent = status;
    metric.classList.remove("up", "blocked", "warn");

    if (status === "UP" || status === "OK") {
      metric.classList.add("up");
    } else if (status === "BLOCKED" || status === "DENIED" || status === "ERROR") {
      metric.classList.add("blocked");
    } else {
      metric.classList.add("warn");
    }

    detailsElement.textContent = details;
  }

  function setOverall(status) {
    const overall = element("overallStatus");
    overall.textContent = status;
    overall.classList.remove("up", "blocked");

    if (status === "UP") {
      overall.classList.add("up");
    } else {
      overall.classList.add("blocked");
    }
  }

  function getApiKey() {
    return localStorage.getItem(localKeyName) || "";
  }

  function headersWithKey() {
    const apiKey = getApiKey();

    if (!apiKey) {
      return {};
    }

    return {
      "X-AIRA-API-Key": apiKey
    };
  }

  async function fetchJson(name, url, headers) {
    const response = await fetch(url, {
      method: "GET",
      headers: headers || {}
    });

    if (!response.ok) {
      throw new Error(name + " returned HTTP " + response.status);
    }

    return response.json();
  }

  function configureLinks() {
    element("detectedHostText").textContent = "Detected host: " + host;

    element("linkApiHealth").href = endpoints.apiHealth;
    element("linkPortalReadiness").href = endpoints.portalReadiness;
    element("linkAgentSummary").href = endpoints.agentSummary;
    element("linkGovernanceReadiness").href = endpoints.governanceReadiness;
    element("linkEvidenceReadiness").href = endpoints.evidenceReadiness;
    element("linkReleaseReadiness").href = endpoints.releaseReadiness;
  }

  async function runChecks() {
    element("consoleOutput").textContent = "Running AIRA Portal checks against host: " + host;
    setOverall("CHECKING");

    let failures = 0;

    try {
      const portal = await fetchJson("Portal readiness", endpoints.portalReadiness);
      setMetric("portalStatus", "portalDetails", portal.status, "Portal URL: " + portal.portalUrl);
      log("Portal readiness: " + portal.status);
      if (portal.status !== "UP") failures++;
    } catch (error) {
      failures++;
      setMetric("portalStatus", "portalDetails", "ERROR", error.message);
      log(error.message);
    }

    const protectedHeaders = headersWithKey();

    if (!protectedHeaders["X-AIRA-API-Key"]) {
      setMetric("agentStatus", "agentDetails", "DENIED", "API key required.");
      setMetric("governanceStatus", "governanceDetails", "DENIED", "API key required.");
      setMetric("evidenceStatus", "evidenceDetails", "DENIED", "API key required.");
      setMetric("packStatus", "packDetails", "DENIED", "API key required.");
      setMetric("gateStatus", "gateDetails", "WARN", "Enter an API key to validate protected APIs.");
      setOverall("BLOCKED");
      log("Protected checks skipped because no API key is set.");
      return;
    }

    try {
      const agents = await fetchJson("Agent summary", endpoints.agentSummary, protectedHeaders);
      setMetric("agentStatus", "agentDetails", agents.status, "Active agents: " + agents.activeAgents + ", prompt versions: " + agents.promptVersions);
      log("Agent summary: " + agents.status);
      if (agents.status !== "UP") failures++;
    } catch (error) {
      failures++;
      setMetric("agentStatus", "agentDetails", "ERROR", error.message);
      log(error.message);
    }

    try {
      const governance = await fetchJson("Governance readiness", endpoints.governanceReadiness, protectedHeaders);
      setMetric("governanceStatus", "governanceDetails", governance.status, "Control gates: " + governance.controlGates + ", failClosed: " + governance.failClosed);
      log("Governance readiness: " + governance.status);
      if (governance.status !== "UP") failures++;
    } catch (error) {
      failures++;
      setMetric("governanceStatus", "governanceDetails", "ERROR", error.message);
      log(error.message);
    }

    try {
      const evidence = await fetchJson("Evidence readiness", endpoints.evidenceReadiness, protectedHeaders);
      setMetric("evidenceStatus", "evidenceDetails", evidence.status, "Artifacts: " + evidence.evidenceArtifacts + ", traceability: " + evidence.traceabilityLinks);
      log("Evidence readiness: " + evidence.status);
      if (evidence.status !== "UP") failures++;
    } catch (error) {
      failures++;
      setMetric("evidenceStatus", "evidenceDetails", "ERROR", error.message);
      log(error.message);
    }

    try {
      const pack = await fetchJson("Evidence pack detail", endpoints.evidencePack, protectedHeaders);
      const artifacts = await fetchJson("Evidence pack artifacts", endpoints.evidenceArtifacts, protectedHeaders);
      setMetric("packStatus", "packDetails", "OK", pack.evidence_pack_key + " with " + artifacts.length + " artifacts.");
      log("Evidence pack: " + pack.evidence_pack_key);
      if (!pack.evidence_pack_key || artifacts.length < 4) failures++;
    } catch (error) {
      failures++;
      setMetric("packStatus", "packDetails", "ERROR", error.message);
      log(error.message);
    }

    try {
      const release = await fetchJson("Release readiness", endpoints.releaseReadiness, protectedHeaders);
      if (release.status === "UP" && release.mvpReady === true && release.failClosed === true) {
        log("Release readiness: UP / MVP_READY / failClosed true");
      } else {
        failures++;
        log("Release readiness is not fully ready.");
      }
    } catch (error) {
      failures++;
      log(error.message);
    }

    if (failures === 0) {
      setMetric("gateStatus", "gateDetails", "UP", "Portal checks passed against host " + host + ".");
      setOverall("UP");
      log("All portal checks passed.");
    } else {
      setMetric("gateStatus", "gateDetails", "BLOCKED", failures + " portal check(s) failed.");
      setOverall("BLOCKED");
      log("Portal checks completed with failures: " + failures);
    }
  }

  function boot() {
    configureLinks();

    const saved = getApiKey();

    if (saved) {
      element("apiKeyInput").value = saved;
    }

    element("saveKeyButton").addEventListener("click", function () {
      localStorage.setItem(localKeyName, element("apiKeyInput").value || "");
      log("API key saved locally for host: " + host);
    });

    element("clearKeyButton").addEventListener("click", function () {
      localStorage.removeItem(localKeyName);
      element("apiKeyInput").value = "";
      log("API key cleared for host: " + host);
    });

    element("runChecksButton").addEventListener("click", runChecks);

    runChecks();
  }

  document.addEventListener("DOMContentLoaded", boot);
})();