# POC-1B Test Plan

## Required Tests

1. Suspicious login event creation.
2. Repeated bad password auto-triage.
3. Account auto-lock after threshold.
4. Login denied while locked.
5. Unlock request creation.
6. Security officer unlock approval.
7. Unlock rejection keeps account locked.
8. Login allowed after approved unlock.
9. Step-up required for high-risk login.
10. Step-up success allows login.
11. Step-up failure denies login.
12. OPA login risk policy produces decision evidence.
13. OPA account lock policy produces decision evidence.
14. OPA step-up policy produces decision evidence.
15. Flowable unlock workflow reaches approved end state.
16. Flowable unlock workflow reaches rejected end state.
17. Security login risk dashboard loads.
18. Incident review screen loads.
19. Unlock approval screen loads.
20. Randomized MF-LOGIN-RISK-001 through MF-LOGIN-RISK-040 validation.

## Target

POC-1B is 10/10 only when all tests pass and evidence is generated.