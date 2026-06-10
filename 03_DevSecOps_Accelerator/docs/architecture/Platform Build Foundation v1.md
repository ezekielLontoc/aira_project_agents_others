\# Platform Build Foundation v1



\## Purpose



This document defines the initial multi-module Maven build foundation for the AIRA DevSecOps Accelerator.



\## Parent Module



aira-devsecops-accelerator



\## Child Modules



| Module | Port | Purpose |

|---|---:|---|

| accelerator-api | 9090 | API boundary |

| accelerator-security | 9091 | Security and policy |

| accelerator-governance | 9092 | Governance enforcement |

| accelerator-evidence | 9093 | Evidence generation |

| accelerator-agents | 9094 | Agent integration |

| accelerator-observability | 9095 | Runtime observability |



\## Build Command



```powershell

mvn clean install

```



\## Governance Rule



No production-impacting action may execute without human approval.

