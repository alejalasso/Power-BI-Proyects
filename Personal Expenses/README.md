# Personal Expenses Report

## 1. Dashboard Purpose

Is a personal project to track my monthly household expenses while living in Uruguay. It has a detailed view of my expenses separating into different categories such as "apartment expenese" that include rent and services, "cats expenses", "food" and "snacks". 
Also, track expenses of each product individually. For example, how much am I spending on milk each month?

With this project I achieved to have better control over my monthly spending, especially on food and snacks.


## 2. What the Model Does

The model combines the expenses records and a calendar table to calculate expenses by month.

I started drawing the main visuals i want to have and so on the measures i need. Then, i translate that to Power BI
<img width="737" height="481" alt="image" src="https://github.com/user-attachments/assets/50a51677-86f7-481f-b246-44cc760a953d" />


## 3. Solution Architecture

The solution follows a structured schema

### Main Data Sources

The model uses the following logical tables:

#### Expenses_records

Contains the records of expenses that are updated each day through Power BI Service, from the OneDrive file through the reading of receipts of Power Automate. 

#### Calendario
Is the calendar table that supports time-based analysis such as monthly trends.

### Measures

- Total Expenses
- Average month Expenses
- Total Expenses from the last month
- Total Expenses previous month

- KPI Total Snack Expenses 
- KPI Total Food Expenses 

- Targ food: target monthly food expenses expected as maximum
- Targ snack: target monthly snack expenses  expected as maximum 

## Model
<img width="578" height="393" alt="image" src="https://github.com/user-attachments/assets/dfa53506-f60f-4b56-bf74-7c457e5ec370" />

## Power BI report
<img width="847" height="475" alt="image" src="https://github.com/user-attachments/assets/393a720d-4fe6-4106-82ab-e70dd6932c94" />



