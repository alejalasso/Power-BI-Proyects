# Inventory Control & Material Requirements Planning Dashboard

## 1. Dashboard Purpose — Business Problem

In manufacturing environments, one of the main operational risks is running out of the materials required to execute the production plan.

Having enough inventory today is not sufficient. The real challenge is determining whether the available stock, together with incoming purchase orders, will be enough to cover future production requirements according to the Master Production Schedule (MPS).

This dashboard was designed to answer key planning questions such as:

- How much material is currently available?
- How much material is required for all open production orders?
- Which materials are already in transit?
- Will the incoming material arrive before the corresponding manufacturing date?
- How much additional material needs to be purchased?
- What quantity should be prioritized for the next production order at risk?
- What is the latest date to place the purchase order considering supplier lead time?
- Which production orders are at risk of material shortage?
- Which specific materials are causing the risk?

The objective is to transform inventory data into an actionable planning tool that supports procurement, inventory control, and production planning decisions.

---

## 2. What the Model Does

The model combines inventory movements, purchase orders, production orders, supplier lead times, and the Bill of Materials (BOM) to calculate current and future material availability.

### Current Inventory Calculation

Current stock is calculated dynamically using:

- **Received purchase orders** as material inputs.
- **Closed production orders** as material consumption.

The consumption of each material is calculated according to:

- The product manufactured.
- The number of units produced.
- The corresponding material requirement defined in the BOM.

This allows the model to calculate material usage product by product instead of relying on average consumption rates.

---

### Material Requirements for Open Production Orders

For every open production order, the model determines the required quantity of each material using the Bill of Materials.

The calculation considers:

- Product ID
- Production quantity
- BOM base quantity
- Material quantity defined in the BOM
- Manufacturing date

This creates a detailed material requirement for every combination of:

`Production Order → Product → Material`

---

### In-Transit Material Availability

The model evaluates purchase orders that have already been placed but have not yet been delivered.

For each production requirement, the expected delivery date is compared against the manufacturing date.

Only quantities expected to arrive on or before the manufacturing date are considered available for that production order.

This prevents the model from treating all open purchase orders as available inventory regardless of when they are expected to arrive.

---

### Material Shortage Calculation

Material requirements are evaluated chronologically.

For each material, the model considers:

1. Current stock.
2. Incoming material expected to arrive on time.
3. Material requirements from previous production orders.
4. Material required by the current production order.

This allows the dashboard to calculate:

- **Total Required Quantity for Open Orders**
- **Total Purchase Quantity Required**
- **Priority Next Purchase Quantity**
- **Material Shortage at Manufacture Date**
- **Shortage Assigned to the Current Production Order**

The distinction between cumulative shortage and shortage assigned to the current order makes it possible to identify both the overall purchasing requirement and the specific production order generating the shortage.

---

### Purchase Planning

When a shortage is detected, the model identifies:

- The first manufacturing date affected by the shortage.
- The supplier lead time for the corresponding material.
- The latest date when the purchase order should be placed.

The purchase deadline is calculated as:

`Purchase Before Date = First Shortage Manufacture Date - Supplier Lead Time`

This provides a more actionable purchasing recommendation than simply displaying the quantity required.

---

### Production Order Risk

The model also evaluates production orders individually.

A production order is classified as **At Risk** when at least one of its required materials will not be available by its manufacturing date.

The dashboard can then display:

- Number of production orders at risk.
- Percentage of production orders at risk.
- Materials causing the shortage.
- Required quantity.
- Available quantity before production.
- Shortage assigned to the production order.

This allows users to move from a high-level inventory view to the exact production orders that may be impacted.

---

## 3. Solution Architecture

The solution follows an MRP-style data model where material demand is driven by the production schedule.

### Main Data Sources

The model uses the following logical tables:

#### Materials / Inventory

Contains the master data for each material, including:

- Material ID
- Material description
- Category
- Unit of measurement
- Supplier
- Supplier lead time
- Unit cost

#### Bill of Materials — BOM

Defines the quantity of each material required to manufacture a specific quantity of product.

Typical fields include:

- Product ID
- Material ID
- Base product quantity
- Material quantity
- Unit of measurement

#### Production Orders

Contains the production schedule and represents the demand driver of the model.

Typical fields include:

- Production Order ID
- Product ID
- Production units
- Manufacture date
- Production order status

Closed production orders are used to calculate historical material consumption, while open production orders generate future material requirements.

#### Purchase Orders

Contains material procurement transactions.

Typical fields include:

- Purchase Order ID
- Material ID
- Quantity
- Purchase date
- Estimated delivery date
- Actual delivery date
- Status

Delivered purchase orders increase current inventory, while open purchase orders are evaluated as in-transit supply.

---

### Calculated Material Requirements Layer

A calculated material requirements table is generated by combining open production orders with the BOM.

Conceptually:

```text
Open Production Orders
        |
        v
Product + Production Quantity
        |
        v
Bill of Materials
        |
        v
Material Requirement by Production Order
