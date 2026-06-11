# Milestone 14 Validation Repair Evidence

## Issue

The AIRA Portal runtime was working, but the validation script failed because it checked the CSS asset for the text:

Runtime Control Surface

That text correctly belongs to:

accelerator-api/src/main/resources/static/portal/index.html

not:

accelerator-api/src/main/resources/static/portal/assets/aira-portal.css

## Fix

The CSS validation now checks for a CSS-specific token:

--accent

## Acceptance

This repair is accepted when:

- Milestone 14 validation passes.
- Portal page returns 200.
- Portal CSS returns 200.
- Portal JS returns 200.
- Portal readiness returns UP.
- Protected API checks pass.
- Milestone 13 regression gates pass.
- Git commit and push complete.