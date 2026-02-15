# AI Working Agreement (Authoritative)
Project: CS 779 Term Project
Owner: Michael Bohen
Last Updated: 2026-02-15

This document was created via AI

## Purpose
This document defines how AI assistance (GitHub Copilot and optionally ChatGPT) is used in this project. It enforces stable scope, prevents requirement drift, and produces two deliverables:
1) Raw AI session transcript (per session)
2) Decision/requirements summary artifacts (curated)

## Source of Truth (Order of Authority)
1) docs/requirements.md (authoritative requirements + scope)
2) docs/decision-log.md (authoritative decisions)
3) docs/consolidated-summary.md (curated summary of AI collaboration)
4) docs/raw-transcripts/* (raw session transcripts and session notes)
5) Code and diagrams (implementation artifacts)

If any AI suggestion conflicts with docs/requirements.md, it is NOT adopted until requirements are explicitly updated.

## Allowed AI Use
- Generate boilerplate SQL, schema templates, ETL scaffolding, and documentation drafts.
- Suggest options and tradeoffs (performance, normalization/denormalization, indexing).
- Produce synthetic data generators and validation queries.
- Refactor for clarity, consistency, and formatting.

## Disallowed / Guardrails
- AI must NOT invent requirements, entities, or business rules.
- AI must NOT silently change existing requirements or decisions.
- AI must NOT assume technologies, cloud services, or constraints not stated in docs/requirements.md.
- AI output must be validated with test queries, constraints, or evidence before being accepted.

## Session Workflow
For every development session:
1) Create or update a raw transcript file:
   - docs/raw-transcripts/YYYY-MM-DD-sessionNN-{topic}.md
2) Log prompts and accepted output (verbatim where possible).
3) Record validation steps and results.
4) If a decision is made or changed:
   - Update docs/decision-log.md with a new DL-### entry.
5) If requirements change:
   - Update docs/requirements.md and increment version.

## Acceptance Criteria (for any AI-generated code)
AI-generated artifacts are accepted only if:
- They align with docs/requirements.md
- They compile/run
- They pass validation queries (FK integrity, row counts, representative selects)
- They have minimal comments explaining intent and assumptions
