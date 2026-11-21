# CLEAN DATA PROJECT


Starting from a CSV file of credit service data with 93,863 records, I created a schema and an import table in MySQL, then prepared the data for analysis in four main steps. All cleaning was done on a copy of the imported table (`dataset_prueba_c`), keeping the original data untouched.

### 1. Remove Duplicates
Created a copy of the table with an extra `row_num` column, using `ROW_NUMBER()` partitioned over all columns to flag repeated records, and deleted every row with `row_num > 1`.

### 2. Standardize the Data
Reviewed the distinct values of each categorical column, then trimmed whitespace and unified inconsistent labels in `CANAL_CONSOLIDADO` and `LINEA_NEGOCIO` (e.g. `Tele ventas` → `Televentas`). Re-ran the duplicate check after these changes and converted `SALE_REGISTRATION_DATE` from text (ISO 8601 format) to a proper `DATETIME` using `STR_TO_DATE()` and `ALTER TABLE`.

### 3. Handle Null or Blank Values
Checked key columns for nulls and empty strings. Blank `ITEM` values were converted to `NULL`, and a self-join on `ITEM_ID` confirmed no other record could fill them, so they were labeled `'ND'` (no data). Rows with `TOTAL_VALUE = 0` were kept since the rest of their information was complete.

### 4. Remove Unnecessary Columns and Rows
Dropped the helper `row_num` column used during the duplicate removal.