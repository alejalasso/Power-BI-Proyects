# Credit Service

## 1. Dashboard Purpose — Business Problem

An enterprise generates monthly large volumes of tansactions with missing data, duplication of transaction, categories not standardized. This project use Power Query view tools of column quality, column distribution and column profile to identify the issues and make the clean of data before charge to the Power BI model.


https://github.com/user-attachments/assets/50c8df70-3863-405a-b103-c3b79bfe2d7a


## 2. What the Model Does

The model connects transactions of credit service to evaluate per month: total sales, average ticket and cancellation rate.

It allows users to:

* Compare total sales, %total sales and average ticket by bussiness line 
* Distribution of sales by consolidated chanel 
* Drill through detail by month

# 3. Solution Architecture

The solution follows a **star-schema-inspired analytical model**.

### Main Tables

* **`Dataset`**
  Contains credit service transactions

  * **`DimDate`**
  Supports time-based analysis such as monthly trends.
