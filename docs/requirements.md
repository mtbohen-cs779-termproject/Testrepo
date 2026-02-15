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
- Azure SQL database. These are two artificates associated with this. These artifact are immutable and should not be changed directly:
Artifact 1:
Description: The SQL script to create this database
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

## FR-1 Azure SQL Topology Schema
The 
