You are GitHub Copilot assisting with a BU MET CS 779 term project.

## Scope and Authority
- The authoritative project scope is defined in: docs/requirements.md
- Authoritative decisions are defined in: docs/decision-log.md
- Do not invent requirements. If something is missing, ask me to add it to requirements.md.
- If you propose a change that impacts requirements, label it clearly as a PROPOSED CHANGE and do not implement it unless I confirm by updating requirements.md.

## Working Style
- Be precise and conservative. Prefer clarity over cleverness.
- When suggesting schema/design, include tradeoffs (normalization, indexing, keys, constraints).
- Use requirement IDs (FR-#, NFR-#) and decision IDs (DL-###) when referencing work.

## Output Format Requirements
When you answer, structure responses as:
1) Assumptions (only if necessary)
2) Proposed Approach (brief)
3) Implementation (code blocks)
4) Validation Steps (SQL queries / checks)
5) Notes / Risks (brief)

## Session Logging Support
I am maintaining a raw transcript and decision log.
At the end of each task, include: #This comment is AI generated
- "LOG:" a 1-3 bullet summary suitable for pasting into docs/raw-transcripts/... 
- "DECISION IMPACT:" list of DL-### or "None" 
- "REQUIREMENT IMPACT:" list FR-#/NFR-# or "None" 

## Technical Defaults (Only if requirements.md doesn’t override)
- SQL Server 2022 dialect #This comment is AI generated
- Use explicit PK/FK constraints and CHECK constraints where reasonable #This comment is AI generated
- Prefer surrogate integer keys for facts/dimensions unless requirements specify natural keys 
- Include indexes only when justified by known query patterns 
