# Requirements Document
Project: Synthetic Security Log Platform
Course: MET CS 779 – Advanced Database Management
Author: Michael Bohen
Version: 1.0
Last Updated: 2026-02-15

AI Usage: This structure was provided by AI. I reviewed the suggested requirements and modified them / rewrote them in my own words. Material directly created via AI is denoted with "//AI generated" 
---

# 1. Project Objective
Create a proof of concept demonstrating the following items.
Objective A: Ingesting data from a previously built IPAM database within Azure SQL
Objective B: Creating synthetic json formatted logs of 3 representitive logs
Objective C: Importing these logs into Cosmos DB log sources
Objective D: Demonstrating queries for these logs modeling real world operations
Objective E: Optionally exporting DHCP reservation data to the relational database

# 2. In Scope
- Azure SQL database. These artifacts are immutable and should not be changed:
The SQL script to create this database is here:
sql/baseline/cs669-original/code/BohenMichael_CS669_TermProjectIteration6Template.sql
The description of this database is located here:
/sql/baseline/cs669-original/doc/cs669-specifications.md

- Synthetic generation scripts simulating 3 data sources (Palo Alto firewall, CrowdStrike EDR, and Microsoft DHCP)
- Importing these log files into CosmosDB
- Generating sample queries
- ERD diagrams depicting the flow of dataa and ERD
- Optional DHCP reservation

# 3. Out of Scope

- Production-grade security controls. //AI generated
- Real-time streaming architecture. //AI generated
- Full rebuild of CS669 database (only minimal subset required). //AI generated
- Full cross-log correlation engine. //AI generated
- High-availability configuration. //AI generated
- 
# 4. Functional Requirements (FR)

## FR-1 Azure SQL Topology Schema
The 
