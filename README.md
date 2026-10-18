# 🏛️ Academic Monorepo: Relational Database Modeling & Implementation

This repository centralizes a chronological collection of data modeling schemas, logical diagrams, and physical SQL scripts developed during a 9-week academic track at Duoc UC. This portfolio records the complete learning curve across the relational database lifecycle: moving from abstract conceptual designs to bare-metal script compilation and analytical data retrieval.

*   **Database Engine:** Oracle Database (11g / 19c)
*   **Core Tools:** Oracle SQL Developer & Oracle SQL Developer Data Modeler

---

## 📅 Weekly Evolution Timeline (Weeks 1 - 9)

### 🟢 Phase 1: Conceptual Design & Domain Abstraction (Weeks 1 - 3)
*   **Week 1 [BT&Airways v1]: Initial Data Modeling.** Introduction to *Oracle Data Modeler* to map the first system entities, define primary attributes, assign basic structural domains, and document business rules using conceptual notation formats.
*   **Week 2 [BT&Airways v2]: Advanced Relationships Analysis.** Deep-dive into database horizontal cardinally limits (1:1, 1:N). Mapping mandatory vs. optional dependency bounds across tightly coupled tables (passengers, reservations, flights, baggage).
*   **Week 3 [HiLogic Solutions]: Extended Entity-Relationship Modeling (ERD-E).** Introduction to structural hierarchical designs. Modeling data inheritance using supertypes and exclusive/total subtypes (e.g., separating Indefinite Contracts from Intern Contracts to prevent sparse tables and null attribute overheads).

### 🟡 Phase 2: Normalization & Logical Architecture (Weeks 4 - 5)
*   **Week 4 [Ministerio del Trabajo]: The Normalization Framework.** Applying the Three Classical Normal Forms (**1NF, 2NF, 3NF**) starting from unstructured flat-file business forms. Purging multi-valued attributes and eliminating transitive dependencies via isolated master catalog tables.
*   **Week 5 [Retail Solari S.A.]: Advanced 3NF Refactoring & Automatic DDL.** Deep restructuring exercise over an inherited, non-normalized conceptual legacy layout. Utilizing *Data Modeler’s* engineering tool to generate automatic Data Definition Language (DDL) physical scripts for the first time.

### 🔴 Phase 3: Physical Compilation & Cloud Connectivity (Week 6)
*   **Week 6 [Consultorio Santa Gema]: Remote Schema Inception.** Migrating from a purely visual canvas to a real physical runtime using *Oracle SQL Developer*. Independently configuring an isolated schema environment (`PRY2204_S6`) connected remotely to Oracle Cloud. Writing hand-crafted scripts to build tables, primary keys (`PRIMARY KEY`), foreign keys (`FOREIGN KEY`), unique indices (`UNIQUE`), and validation bounds (`CHECK`).

### 🔵 Phase 4: Data Ingestion & Programmatic Retrieval (Semanas 7 - 9)
*   **Week 7 [Holding Carpenter]: Data Population & Relational Gravity.** Executing strategic Data Manipulation Language (DML) row ingestion, ordering operations sequentially to prevent foreign key integrity violations. Creating database `SEQUENCE` objects and native `IDENTITY` mechanisms to automate unique ID assignments.
*   **Week 8 [Taller Mikes Ltda.]: Schema Evolution & Base Querying.** Altering active production table structures using `ALTER TABLE` commands (dropping calculated columns, mutating attributes). Writing base analytical data extraction filters using the `SELECT` statement paired with string concatenations (`||`), logical operators (`BETWEEN`, `OR`), and row sorting routines (`ORDER BY`).
*   **Week 9 [EFT ANFP]: Capstone Course Consolidation.** Final integration track merging all semester competencies: abstract domain modeling, high-fidelity 3NF normalization, hand-written polymorphic DDL tables generation, sequential sequence-driven data population, and complex analytical reporting using calculations and multi-column sorting filters.

---

## ⚙️ Applied Database Configuration Matrix

| Target Object / Rule | Native Code Configuration | Academic Purpose |
| :--- | :--- | :--- |
| **Comuna ID Automation** | `START WITH 1101 INCREMENT BY 6` | Automating unique relational row keys via database sequence objects. |
| **Compañía ID Automation** | `START WITH 10 INCREMENT BY 5` | Custom management of corporate transaction identifiers. |
| **Nacionalidad / Región IDs** | `GENERATED ALWAYS AS IDENTITY` | Applying native Oracle autoincremental columns. |
| **Corporate Floors (Salary)** | `CHECK (sueldo >= 450000)` \| `(sueldo >= 510000)` | Shifting validation rules down to the data storage tier. |
| **National Identifier Mask** | `CHECK (dv BETWEEN '0' AND '9' OR dv = 'K')` | Enforcing strict verification formatting masks at the gateway. |
| **Environment Isolation** | Dedicated weekly users (`S6`, `S8`, `S9`) | Implementing Principle of Least Privilege (PoLP) away from `SYS/SYSTEM`. |

---
**Core Infrastructure Tech Stack:** Oracle Database Engine, PL/SQL Runtime Engine, Oracle SQL Developer Data Modeler.
