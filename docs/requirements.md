# Requirements Document
Project: Synthetic Security Log Platform
Course: MET CS 779 – Advanced Database Management
Author: Michael Bohen
Version: 1.0
Last Updated: 2026-02-15

AI Usage: I used AI to generate the structure of this document. I reviewed the suggested requirements and modified them / rewrote them in my own words. 
I noted the marterial I created directly via AI with the text "//AI generated" 

---

# 1. Project Objective
Create a proof of concept demonstrating the following items.

Objective A: Ingesting data from a previously built IPAM database within Azure SQL

Objective B: Creating synthetic json formatted logs of 3 representitive logs

Objective C: Importing these logs into Cosmos DB log sources

Objective D: Demonstrating queries for these logs modeling real world operations

Objective E: Optionally exporting DHCP reservation data to the relational database

# 2. In Scope
- Azure SQL database.
  These are two artificates associated with this. These artifact are immutable and should not be changed directly:
  *Artifact 1:
  
    *Description: The SQL script to create this database
  
    Location: sql/baseline/cs669-original/code/BohenMichael_CS669_TermProjectIteration6Template.sql
  
  Artifact 2:
  
    Description: The specifications of this database is located here:
  
    Location: /sql/baseline/cs669-original/doc/cs669-specifications.md
  
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
## FR-1 Site and subnet query
The Python generation scripts should retrieve the following context from the existing Azure SQL database. 
- The subnets in use in the organization
- The sites in use in the organization
- The function of each subnet
- This will initially be implemented by retreiving them from Artifact 1 and Artifact 2. Once successful, we will implement this via an API connection to Azure SQL

- ## FR-2 Firewall Log Generator
A Python Script should have the following functionality:
- Create synthetic firewall events simulating the network traffic logs
- The synthetic logs should depict
- This can be initially implemented with AI generated sources, but should then incoporate the data learned via FR-1
- Have the following parameters:
  - Start Time
  - Stop Time
  - Number of Events
  - Number of hosts
  - Threat IP address
  - Threat DNS name
  - Percent IP Address Threat Events
  - Percent DNS threat events
- Output JSON files suitable for Cosmos DB ingestion. // AI generated requirement

- ## FR-3 EDR Log Generator
- Create synthetic events simultaing the activities from an EDR tool such as CrowdStrike running on an endpoint
- Include the following attributes
  - Hostname
  - Time
  - File Name
  - File Hash
  - Activity Tpye
- Include the following configurable parameters:
  - Start Time
  - Stop Time
  - Name of malicious process with a default value if this not not configured
  - Hash of malicious process with a default value if this not not configured
  - Burstiness
  - Percent of events malicious
  - Percent of endpoints infected
- Output JSON files suitable for Cosmos DB ingestion. // AI generated requirement

- ## FR-4 DHCP Log Generator
- Create synthetic events simulating a DHCP server
- Include the following attributes
  - DeviceName
  - IP Address
  - Scope
  - Time
- Output JSON files suitable for Cosmos DB ingestion. // AI generated requirement


## FR-5 Cosmos DB Data Model
Cosmos DB must: // AI generated requirement
- Store generated JSON logs. // AI generated requirement
- Use defined containers. // AI generated requirement
- Define a partition key per container. // AI generated requirement

Partition key choice must be documented in Decision Log. // AI generated requirement

## FR-7 Investigative Queries
We will develop three queries within Cosmos DB
  - Query 1: Locate the infected endpoints based on firewall activity 
  - Query 2: Locate malcious process and malicious file hash based on EDR activity
  - Query 3: Determine which device was assigned a specific IP address at a specific time
  - Query 4 (option) - Demonstrate joining data between multiple data sources

## FR-8 Azure SQL Topology Schema (Optional)
The script must perform the following tasks:
- Retrieve DHCP reservation events from Cosmos DB. // AI generated requirement
- Upsert into Azure SQL `DHCP_Reservation` table. // AI generated requirement
- Enforce deduplication logic. // AI generated requirement


# 5. Non-Functional Requirements (NFR)

## NFR-1 Auditability
All AI interactions must be logged and preserved in: // AI generated requirement
- docs/raw-transcripts/ // AI generated requirement
- docs/consolidated-summary.md // AI generated requirement

---

## NFR-2 Requirement Authority
Requirements may only change via explicit version update of this document. // AI generated requirement

---

## NFR-3 Code Clarity
- All Python code must include docstrings. // AI generated requirement
- SQL must include comments explaining constraints. // AI generated requirement
- All Code must have the following additional qualities
  - Be easy to read and understand for people new to Python
  - Minimize the use of third party modules
  - Avoid using aliases
  - Avoid excessive complexity
---

## NFR-4 Demonstration Readiness
The project must be executable and demoable within 10 minutes:
- Data generation // AI generated requirement
- Data load // AI generated requirement
- Query execution // AI generated requirement

---

## NFR-5 Validation
All generated data must:
- Conform to expected JSON schema. // AI generated requirement
- Successfully load into Cosmos DB. // AI generated requirement
- Pass sample validation queries. // AI generated requirement

---


# 6. Data Architecture Requirements

## DR-1 Hybrid Architecture
- Relational data: Azure SQL // AI generated requirement
- Semi-structured logs: Cosmos DB // AI generated requirement
- Data flow must be represented in diagram. // AI generated requirement

---

## DR-2 Partitioning Strategy
Cosmos DB containers must define partition keys. // AI generated requirement
Justification required in Decision Log (DL-###). // AI generated requirement

---

# 7. Assumptions

- Azure resources are pre-provisioned. // AI generated requirement
- Time constraint is 20 hours. // AI generated requirement
- Log correlation may be minimal or independent per log type. // AI generated requirement
 
---

# 8. Risks

- Synthetic log correlation complexity. // AI generated requirement
- Cosmos DB partition key mis-selection. // AI generated requirement
- Scope expansion beyond time constraint. // AI generated requirement

---
