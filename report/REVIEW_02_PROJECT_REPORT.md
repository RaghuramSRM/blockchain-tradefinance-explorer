# LAB WORK PROJECT (LWP) REVIEW 02 REPORT
## DEPARTMENT OF COMPUTER SCIENCE AND ENGINEERING
### KPR INSTITUTE OF ENGINEERING AND TECHNOLOGY
**Course Code & Name:** U21CS504 – Web Technologies Laboratory  
**Regulation:** 2021 | **Academic Year:** 2026 – 2027  
**Project Title:** **Trade Finance Blockchain Explorer (ChainDocs)**  

---

### EVALUATION RUBRIC CRITERIA & SCORE MAPPING (TOTAL: 85 MARKS)

| Rubric Component | Max Marks | Implementation Highlights in ChainDocs |
| :--- | :---: | :--- |
| **Application Uniqueness** | **5** | Institutional Trade Finance Web platform featuring cryptographic SHA-256 document integrity anchoring and an append-only hash-linked blockchain ledger. |
| **Client-Side Validation using JavaScript** | **10** | Robust DOM and Regex validation for user registration, multi-party transaction forms, email formatting, and password policy (aligns with Ex 3). |
| **Server-Side Implementation (PHP / Servlets / Fake APIs)** | **10** | Modular REST APIs in PHP with JWT authentication, role-based authorization, and external SWIFT FX simulated rates integration (aligns with Ex 4 & 5). |
| **Database Schema & CRUD Operations** | **10** | Normalized 11-table relational database design (MySQL / PDO) supporting CRUD on trade transactions, audit logs, and ledger entries. |
| **Implementation & Presentation Quality** | **20** | Professional UI with HTML5, CSS3, Bootstrap 5, Chart.js financial analytics, and interactive cryptographic ledger block explorer. |
| **Project Report Quality** | **30** | Comprehensive technical report detailing Aim, Objectives, Architecture, Schemas, API Specs, Test Cases, and Viva Q&A. |

---

## 1. AIM & OBJECTIVES

### 1.1 Aim
To design and develop a responsive, full-stack, enterprise-grade web application named **Trade Finance Blockchain Explorer (ChainDocs)** using HTML5, CSS3, JavaScript, PHP, and MySQL (compatible with XAMPP). The application facilitates multi-party trade settlement, Letter of Credit (LC) authorization, SHA-256 document verification, and tamper-evident audit ledger tracking.

### 1.2 Objectives
1. **Client-Side Verification**: Implement interactive input forms with JavaScript client-side validation to enforce data integrity before transmission.
2. **RESTful Architecture**: Develop modular server-side REST APIs for authentication, trade transactions, ledger verification, and risk metrics.
3. **Cryptographic Data Integrity**: Implement SHA-256 server-side hashing to generate unique digital fingerprints for uploaded trade instruments.
4. **Blockchain Audit Trail**: Construct an append-only, hash-linked ledger where each block references predecessor hashes to prevent double-financing fraud.
5. **Role-Based Access Control (RBAC)**: Enforce strict role authorization across four personas: `ADMIN`, `BANK`, `CORPORATE`, and `AUDITOR`.

---

## 2. SYSTEM ARCHITECTURE & MODULE DESIGN

### 2.1 Architectural Flow Diagram
```
[ Client Browser (HTML5 + CSS3 + Vanilla JS + Chart.js) ]
                        |
            (HTTP / REST JSON & Fetch API)
                        v
[ Central API Gateway & Security Dispatcher (PHP 8 + JWT) ]
                        |
      +-----------------+-----------------+
      |                 |                 |
      v                 v                 v
[Auth Service]   [Trade Tx Service]  [Ledger & Document Engine]
 (JWT + RBAC)     (State Machine)      (SHA-256 Hash Chaining)
      |                 |                 |
      +-----------------+-----------------+
                        |
            (PDO / Prepared Statements)
                        v
        [ Relational Database (11 Tables) ]
               (MySQL / SQLite / XAMPP)
```

### 2.2 Core Modules
1. **Authentication & Identity Service**: Handles user registration, bcrypt password hashing, and HMAC SHA-256 JWT generation.
2. **Trade Transaction Engine**: Enforces multi-party state transitions (`PENDING` &rarr; `IN_PROGRESS` &rarr; `COMPLETED` / `DISPUTED`).
3. **Cryptographic Document Verifier**: Computes SHA-256 checksums of trade documents and verifies them against immutable ledger anchors.
4. **Append-Only Blockchain Ledger**: Links chronological transaction events via parent block hashes (`previous_hash` &rarr; `entry_hash`).
5. **Risk & Regulatory Analytics**: Computes Basel III risk ratings and visualizes transactional trends using Chart.js.

---

## 3. DATABASE DESIGN & SCHEMA

The database comprises 11 normalized tables with foreign keys and cascade integrity constraints:

### 3.1 Entity Relationship Summary
1. `organizations`: Master table for Banks, Corporates, and Audit institutions.
2. `users`: Identity records with hashed passwords and assigned roles (`ADMIN`, `BANK`, `CORPORATE`, `AUDITOR`).
3. `organization_members`: Junction table establishing membership and governance roles.
4. `refresh_tokens`: Revocable token storage for session security.
5. `trade_transactions`: Master table for Letters of Credit, commodity contracts, and currency amounts.
6. `transaction_history`: Audit trail tracking every state transition with timestamps and actor IDs.
7. `documents`: Metadata, MIME types, file references, and SHA-256 digests.
8. `ledger_entries`: Cryptographic blockchain blocks containing previous block hash, entry hash, and metadata.
9. `alerts`: Real-time system notifications for disputes and integrity mismatches.
10. `risk_scores`: Institutional counterparty ratings computed via standardized risk algorithms.
11. `audit_logs`: Immutable system activity logs for regulatory compliance.

---

## 4. REST API SPECIFICATIONS

| Method | Endpoint | Description | Role Access |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/auth/register` | Register new participant & organization | Public |
| `POST` | `/api/auth/login` | Authenticate and retrieve JWT token | Public |
| `GET` | `/api/transactions` | List all trade transactions | Authenticated |
| `POST` | `/api/transactions` | Initiate new Letter of Credit / Contract | CORPORATE, BANK |
| `POST` | `/api/transactions/{id}/approve` | Bank approves and moves status to `IN_PROGRESS` | BANK, ADMIN |
| `POST` | `/api/transactions/{id}/complete` | Settle trade and mark as `COMPLETED` | Authenticated |
| `POST` | `/api/transactions/{id}/dispute` | Raise dispute on trade delivery | CORPORATE, BANK |
| `GET` | `/api/documents` | Retrieve uploaded trade documents | Authenticated |
| `POST` | `/api/documents` | Upload document and anchor SHA-256 hash | Authenticated |
| `POST` | `/api/documents/{id}/verify` | Cryptographically verify document hash against ledger | Authenticated |
| `GET` | `/api/ledger` | Query the full immutable blockchain audit chain | Authenticated |
| `GET` | `/api/analytics` | Fetch volume aggregations and risk metrics | Authenticated |
| `GET` | `/api/fake-swift-rates` | Simulated external SWIFT FX API rates | Public |

---

## 5. CLIENT-SIDE VALIDATION RULES (JAVASCRIPT)

In compliance with **Exercise 3** of the laboratory manual:
1. **Email Format**: Regex verification (`/^[^\s@]+@[^\s@]+\.[^\s@]+$/`) ensures only standard corporate email formats are submitted.
2. **Password Length**: Minimum 6 characters required; real-time equality check between `password` and `confirm_password`.
3. **Required Fields & Numbers**: Validates that trade contract amounts are strictly positive numeric values (`amount > 0`).
4. **Terms & Agreement**: Form submission is blocked unless legal terms checkbox is toggled.
5. **Dynamic DOM Feedback**: Clear `.is-invalid` and `.is-valid` CSS state classes applied without page refreshes.

---

## 6. TEST CASES & EXECUTION RESULTS

| Test Case ID | Test Description | Input Data | Expected Output | Actual Result |
| :--- | :--- | :--- | :--- | :--- |
| **TC-01** | Client-Side Email Validation | `user@invalid` | Form displays error message; submission halted | **PASS** |
| **TC-02** | Password Confirmation Match | Pwd1: `Admin123`, Pwd2: `Admin456` | "Passwords do not match" alert triggered | **PASS** |
| **TC-03** | Server Authentication | Valid Email & Password | Returns 200 OK + HMAC SHA-256 JWT Token | **PASS** |
| **TC-04** | Bank Authorization Workflow | Approve action on Pending LC | Status transitions to `IN_PROGRESS` | **PASS** |
| **TC-05** | Unauthorized State Change | Corporate user attempting Bank approval | Server returns 403 Forbidden | **PASS** |
| **TC-06** | Cryptographic Document Hashing | Upload `Letter_of_Credit.pdf` | Computes valid 64-char SHA-256 hex digest | **PASS** |
| **TC-07** | Ledger Hash Continuity | Compare Block N `previous_hash` with Block N-1 `entry_hash` | Hashes match exactly with zero breaks | **PASS** |

---

## 7. GENERAL VIVA QUESTIONS & ANSWERS (CURRICULUM ALIGNED)

1. **What is the difference between client-side and server-side validation?**  
   *Answer:* Client-side validation runs in the browser using JavaScript to provide instant feedback and reduce server load. Server-side validation runs in PHP/Servlets to guarantee security because client-side checks can be bypassed.
2. **What is the purpose of SHA-256 in ChainDocs?**  
   *Answer:* SHA-256 creates a unique 256-bit (64-character hexadecimal) mathematical digest of trade documents. Any alteration of a document changes its hash, immediately alerting participants to fraudulent modifications.
3. **How does the append-only ledger simulate a blockchain?**  
   *Answer:* Each ledger record includes the hash of the preceding block (`previous_hash`). Modifying any historical block invalidates every downstream block in the chain.
4. **What is a PreparedStatement and why is it essential?**  
   *Answer:* Prepared statements precompile SQL statements on the database engine and separate user parameters from query logic, completely preventing SQL Injection attacks.
5. **How does JWT authentication operate?**  
   *Answer:* The server signs user identity claims into an encoded token using a cryptographic secret key (`HS256`). The client includes this token in the `Authorization: Bearer` header on subsequent API requests.

---

## 8. INSTRUCTIONS TO RUN LOCALLY

### Quick Start:
1. Double-click `C:\chaindocs\start_server.bat` (or run `& "C:\chaindocs\bin\php\php.exe" -S 127.0.0.1:8888 -t "C:\chaindocs" "C:\chaindocs\router.php"` in PowerShell).
2. Open your web browser to: **`http://127.0.0.1:8888`**
3. Use the following pre-configured evaluation accounts:
   - **Administrator**: `admin@chaindocs.io` | Password: `Password123!`
   - **Commercial Bank**: `bank@scb.com` | Password: `Password123!`
   - **Corporate Trader**: `buyer@apexcommodities.com` | Password: `Password123!`
   - **Regulatory Auditor**: `auditor@deloitte.com` | Password: `Password123!`
