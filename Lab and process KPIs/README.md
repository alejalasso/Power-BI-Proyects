# Pharmaceutical Laboratory Lead Time & SLA Analysis

## 1. Dashboard Purpose — Business Problem

Pharmaceutical laboratory data can contain multiple analytical records for the same batch, making it difficult to evaluate overall batch performance directly from the raw dataset.

This project was developed to transform analysis-level operational data into a structured analytical model capable of monitoring:

- Laboratory lead times
- SLA compliance
- Batch processing performance
- Process bottlenecks

The objective is to replace manual calculations and pivot-table-based reporting with a scalable Power BI solution that automatically updates performance indicators when new data is loaded.

It improves:

- Calculation consistency
- Data traceability
- Reporting efficiency
- Identification of bottlenecks
- Monitoring of laboratory performance
- Automatic KPI updates after data refresh

---

## 2. What the Model Does

The project applies **ETL (Extract, Transform, Load)** principles to transform a CSV containing multiple analytical records per pharmaceutical batch into an analytical model.

The model:

- Cleans and transforms the source data using Power Query.
- Consolidates analysis-level records into a batch-level structure.
- Calculates key dates for each batch.
- Measures laboratory reception, processing, review and approval times.
- Evaluates SLA compliance.
- Identifies batches and processes contributing to longer cycle times.
- Automatically recalculates KPIs when the source data is refreshed.

An intermediate batch-level table is used to ensure that indicators such as lead time and SLA are calculated at the correct level of granularity.

---

## 3. Solution Architecture

The solution follows an **ETL and star-schema-inspired analytical approach**.

### Data Flow

```text
CSV Source
    |
    v
Power Query
Extract & Transform
    |
    v
Analysis-Level Data
Multiple tests per batch
    |
    v
Batch-Level Transformation
    |
    v
Analytical Data Model
    |
    +------------------+
    |                  |
    v                  v
Lead Time          SLA Compliance
Analysis               Analysis
    |                  |
    +--------+---------+
             |
             v
       Power BI Dashboard