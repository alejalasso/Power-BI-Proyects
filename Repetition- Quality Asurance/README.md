# Laboratory Analytical Repetitions Dashboard

## 1. Dashboard Purpose — Business Problem

Repeated laboratory analyses increase workload, operating costs, and may delay product release. However, repetitions can originate from different causes and therefore require different corrective actions.

This Power BI dashboard was developed to monitor analytical repetitions through three main categories:

- **OOS — Out of Specification**
- **OOT — Out of Trend**
- **Reworks**

The objective is to track laboratory performance, identify the main causes behind repetitions, evaluate corrective actions, and support continuous improvement within the Quality Control process.

The dashboard helps answer questions such as:

- How is the laboratory repetition rate evolving over time?
- Which type of repetition contributes the most?
- Which causes are responsible for OOS, OOT, and Rework events?
- Which analysts are associated with repeated laboratory issues?
- Which products show repetitions related to manufacturing problems?
- Which corrective actions are most frequently implemented?



https://github.com/user-attachments/assets/2c129bfc-0e40-4971-90c0-df7f7381e7e7





---

## 2. What the Model Does

The Power BI model combines laboratory analyses and repetition records to evaluate performance from different perspectives.

### Overall Performance

The Overview page provides:

- Overall repetition rate vs target
- OOS, OOT, and Rework KPIs
- Monthly and yearly trends
- Year-over-year performance comparison
- Corrective action distribution
- Assigned cause analysis

This provides a high-level view of laboratory performance and helps identify areas requiring further investigation.

### OOS & OOT Analysis

The OOS and OOT page focuses on understanding the causes behind analytical deviations.

The model analyzes:

- Assigned causes
- Corrective actions
- Analysts associated with the **Man** cause
- Products associated with the **Product** cause

Product-related repetitions are particularly relevant because they may indicate that the result did not comply with specification due to an issue originating during the manufacturing process rather than laboratory execution.

### Rework Analysis

The Rework page focuses on analyses that must be performed again due to issues identified during or after the original execution.

The dashboard highlights:

- Analysts with the highest number of reworks
- Root causes such as analyst, equipment, or procedure-related issues
- Corrective actions implemented to prevent recurrence

This analysis helps identify opportunities for training, equipment improvement, procedure revision, and process standardization.

---

## 3. Solution Architecture

The solution follows a **star-schema-inspired analytical model** that separates laboratory analysis data from repetition events and descriptive dimensions.

### Main Data Sources

#### Analysis Data

Contains the laboratory analyses performed. This table is used as the reference population for calculating repetition rates.

#### Repetition Data

Contains analytical repetition events.
The repetition type classifies each event as:

- OOS
- OOT
- Rework

### Analytical Logic

The overall calculation flow can be represented as:

```text
Laboratory Analyses
        |
        v
 Total Analyses
        |
        +----------------------+
        |                      |
        v                      v
Repetition Records        Time Analysis
        |
        +-----------------------------+
        |              |              |
        v              v              v
       OOS            OOT           Rework
        |              |              |
        +--------------+--------------+
                       |
                       v
              Root Cause Analysis
                       |
            +----------+----------+
            |                     |
            v                     v
     Corrective Actions     Analyst / Product
                               Analysis
