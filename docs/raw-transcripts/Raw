# Repository Readiness Checklist

This is an AI generated checklist to ensure this repository is prepared to begin work.

## 1. Required Folder Structure

Ensure your repository contains the following folders:

-   docs/
-   docs/raw-transcripts/
-   docs/appendix/ (optional but recommended)
-   sql/
-   generators/ (or src/)
-   diagrams/
-   evidence/

------------------------------------------------------------------------

## 2. Authority Documents

### 2.1 AI_WORKING_AGREEMENT.md

Location: docs/AI_WORKING_AGREEMENT.md

Checklist:

-   Defines order of authority (requirements \> decisions \>
    implementation)
-   States that requirements must be explicitly versioned
-   Defines AI usage guardrails
-   Defines session logging expectations

------------------------------------------------------------------------

### 2.2 requirements.md

Location: docs/requirements.md

Checklist:

-   Includes Version number
-   Includes Last Updated date
-   Clearly defines In Scope
-   Clearly defines Out of Scope
-   Functional requirements labeled FR-#
-   Non-functional requirements labeled NFR-#
-   Includes auditability requirement

------------------------------------------------------------------------

### 2.3 decision-log.md

Location: docs/decision-log.md

Checklist:

-   Uses DL-### identifiers
-   Each decision references related FR-#
-   Includes rationale
-   Includes validation or evidence reference

------------------------------------------------------------------------

### 2.4 consolidated-summary.md

Location: docs/consolidated-summary.md

Checklist:

-   Contains session index
-   Summarizes AI usage
-   References decision log entries
-   References raw transcripts
-   Describes validation approach

------------------------------------------------------------------------

## 3. Raw Transcript Materials

Ensure:

-   docs/raw-transcripts/\_TEMPLATE-session.md exists
-   At least one real session transcript file exists
-   Each transcript includes:
    -   Prompts
    -   AI responses (verbatim or minimally edited)
    -   What was accepted or rejected
    -   Validation checklist

If using ChatGPT PDF exports:

-   Save with consistent naming format\
    Example: 2026-02-15-session01-cosmos-design.pdf

------------------------------------------------------------------------

## 4. Baseline / Prior Work Handling (CS669 Reuse)

Structure:

-   sql/baseline/cs669-original/
-   sql/azure-adaptation/

Checklist:

-   Baseline stored in baseline/
-   Baseline files marked immutable with header comments
-   Adaptations stored separately in azure-adaptation/
-   No direct edits to baseline files

------------------------------------------------------------------------

## 5. Implementation Readiness

Ensure:

-   Root-level README.md exists
-   .gitignore includes:
    -   .env
    -   **pycache**/
    -   \*.pyc
    -   local settings files
-   generators/README.md exists
-   evidence/ contains at least one validation artifact

------------------------------------------------------------------------

## 6. Traceability (Optional but Recommended)

-   Commit messages reference requirement IDs (e.g., FR-3)
-   Optional file: docs/traceability-matrix.md

Example table structure:

  Requirement   Artifact                Evidence
  ------------- ----------------------- ---------------------
  FR-3          firewall_generator.py   cosmos_query_01.png

------------------------------------------------------------------------

# 5-Minute Validation Pass

Before continuing development, confirm:

1.  requirements.md contains a finite, well-defined list of FR-#.
2.  AI_WORKING_AGREEMENT.md clearly states requirement authority.
3.  At least one raw transcript exists.
4.  decision-log.md contains at least one DL-### entry.
5.  README.md includes a demo runbook section.

------------------------------------------------------------------------

# Recommended Workflow (1 Week / \~20 Hours)

## Phase 1 -- Lock Scope (1--1.5 hours)

-   Finalize requirements.md
-   Define explicit out-of-scope items
-   Pre-create placeholder decisions:
    -   DL-001: Cosmos container strategy
    -   DL-002: Partition key strategy
    -   DL-003: Synthetic data burst model
    -   DL-004: Correlation approach

------------------------------------------------------------------------

## Phase 2 -- Define Thin-Slice Demo (30 minutes)

Minimum viable demo path:

1.  Query subnets from Azure SQL
2.  Generate synthetic logs (Firewall, EDR, DHCP)
3.  Load logs into Cosmos DB
4.  Execute 3 representative queries
5.  Present ERD and dataflow diagram

------------------------------------------------------------------------

## Phase 3 -- Branch-Per-Requirement Development

Suggested branch names:

-   feature/fr-1-azure-schema
-   feature/fr-3-firewall-generator
-   feature/fr-4-edr-generator
-   feature/fr-5-dhcp-generator
-   feature/fr-6-cosmos-queries
-   feature/fr-8-dhcp-upsert (optional)

Merge only when:

-   Requirement is satisfied
-   Validation steps completed
-   Decision log updated if necessary
-   Transcript saved

------------------------------------------------------------------------

## Phase 4 -- Controlled AI Usage

For each AI-assisted session:

1.  Paste bootstrap prompt into Copilot
2.  Work one function or module at a time
3.  Require validation steps
4.  Copy relevant exchanges into transcript file
5.  Log any design decisions
6.  Update requirements version if scope changes

------------------------------------------------------------------------

## Phase 5 -- Final Packaging (3--4 hours)

-   Finalize consolidated-summary.md
-   Export transcripts to PDF if required
-   Capture Cosmos query screenshots
-   Verify demo runbook steps
-   Create final release branch: release/submission-v1

------------------------------------------------------------------------

# Scope Safety Recommendation

If time becomes constrained:

-   Do not fully port CS669 schema.
-   Implement minimal topology schema only.
-   Prioritize Cosmos modeling and query demonstration.
-   Treat DHCP upsert as optional stretch goal.
