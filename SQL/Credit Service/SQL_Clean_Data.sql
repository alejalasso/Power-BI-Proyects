-- 1. Remove Duplicates

-- First I see the table and its columns
USE creditdb;
SELECT*
FROM `dataset prueba`;

-- I identify how many duplicates are
WITH checkdup AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY TRANSACTION_ID, ITEM_ID, CONTRACT_ID, SALE_REGISTRATION_DATE, ITEM, LOCALITY, 
NEIGHBORHOOD, SUBCATEGORY, MERCHANT_NAME, BRANCH_MERCHANT, SELLER_NAME, CANAL_CONSOLIDADO, 
LINEA_NEGOCIO, NUMBER_OF_INSTALLMENTS, TOTAL_VALUE, CURRENT_STATUS) AS row_num
FROM `dataset prueba`)
SELECT*
FROM checkdup
WHERE row_num >1;

-- I duplicate the table and add the data and a column called "row_num" where i identified the duplicates

CREATE TABLE dataset_prueba_c (
  `TRANSACTION_ID` text,
  `ITEM_ID` text,
  `CONTRACT_ID` text,
  `SALE_REGISTRATION_DATE` text,
  `ITEM` text,
  `LOCALITY` text,
  `NEIGHBORHOOD` text,
  `SUBCATEGORY` text,
  `MERCHANT_NAME` text,
  `BRANCH_MERCHANT` text,
  `SELLER_NAME` text,
  `CANAL_CONSOLIDADO` text,
  `LINEA_NEGOCIO` text,
  `NUMBER_OF_INSTALLMENTS` int DEFAULT NULL,
  `TOTAL_VALUE` double DEFAULT NULL,
  `CURRENT_STATUS` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO dataset_prueba_c
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY TRANSACTION_ID, ITEM_ID, CONTRACT_ID, SALE_REGISTRATION_DATE,
  ITEM, LOCALITY, NEIGHBORHOOD, SUBCATEGORY, MERCHANT_NAME, BRANCH_MERCHANT, SELLER_NAME,
  CANAL_CONSOLIDADO, LINEA_NEGOCIO, NUMBER_OF_INSTALLMENTS, TOTAL_VALUE, CURRENT_STATUS) AS row_num
FROM `dataset prueba`;

-- delete the duplicates rows
DELETE 
FROM dataset_prueba_c
WHERE row_num > 1;


-- 2. Standarize the Data

SELECT*
FROM dataset_prueba_c;

-- Check unique values in the columns
SELECT distinct ITEM, ITEM_ID
FROM dataset_prueba_c
ORDER BY 1;

SELECT distinct LOCALITY
FROM dataset_prueba_c
ORDER BY 1;

SELECT distinct NEIGHBORHOOD
FROM dataset_prueba_c
ORDER BY 1;

SELECT distinct SUBCATEGORY
FROM dataset_prueba_c
ORDER BY 1;

SELECT distinct SELLER_NAME
FROM dataset_prueba_c
ORDER BY 1;

-- After check unique values in the "CANAL_CONSOLIDADO" column, make adjustments in values
SELECT distinct CANAL_CONSOLIDADO
FROM dataset_prueba_c
ORDER BY 1;

UPDATE dataset_prueba_c
SET CANAL_CONSOLIDADO= TRIM(CANAL_CONSOLIDADO);

UPDATE dataset_prueba_c
SET CANAL_CONSOLIDADO = 'Centro de Experiencia'
WHERE CANAL_CONSOLIDADO LIKE 'Centro Experiencia%';

UPDATE dataset_prueba_c
SET CANAL_CONSOLIDADO = 'Fuerza de Venta Externa'
WHERE CANAL_CONSOLIDADO LIKE 'Fdv Externa%';

UPDATE dataset_prueba_c
SET CANAL_CONSOLIDADO = 'Puntos Fijos Municipios'
WHERE CANAL_CONSOLIDADO LIKE '%Mpios';

UPDATE dataset_prueba_c
SET CANAL_CONSOLIDADO = 'Televentas'
WHERE CANAL_CONSOLIDADO LIKE 'Tele ventas%';

-- After check unique values in the "LINEA_NEGOCIO" column, make adjustments in values
SELECT distinct LINEA_NEGOCIO
FROM dataset_prueba_c
ORDER BY 1;

UPDATE dataset_prueba_c
SET LINEA_NEGOCIO= TRIM(LINEA_NEGOCIO);

UPDATE dataset_prueba_c
SET LINEA_NEGOCIO= 'Educacion'
WHERE LINEA_NEGOCIO LIKE 'Educaci%';

UPDATE dataset_prueba_c
SET LINEA_NEGOCIO= 'Materiales de Construccion'
WHERE LINEA_NEGOCIO LIKE '% Construcc%';

UPDATE dataset_prueba_c
SET LINEA_NEGOCIO= 'Hogar'
WHERE LINEA_NEGOCIO LIKE '%ogar';

SELECT distinct CURRENT_STATUS
FROM dataset_prueba_c
ORDER BY 1;

-- I check again with the changes in LINEA_NEGOCIO and CANAL_CONSOLIDADO if there is duplicates. And new duplicates not were found.

WITH duplicatecheck as (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY TRANSACTION_ID, ITEM_ID, CONTRACT_ID, SALE_REGISTRATION_DATE, LOCALITY, 
NEIGHBORHOOD, SUBCATEGORY, MERCHANT_NAME, BRANCH_MERCHANT, SELLER_NAME, CANAL_CONSOLIDADO, 
LINEA_NEGOCIO, NUMBER_OF_INSTALLMENTS, TOTAL_VALUE, CURRENT_STATUS) AS rownum2
FROM dataset_prueba_c)

SELECT *
FROM duplicatecheck
WHERE rownum2 > 1;

-- I have to change the SALE_REGISTRATION_DATE to a valid Date-Time
-- First i check the format
SELECT SALE_REGISTRATION_DATE,
STR_TO_DATE(SALE_REGISTRATION_DATE, '%Y-%m-%dT%H:%i:%s.%fZ')
FROM dataset_prueba_c;

-- Make the change
UPDATE dataset_prueba_c
SET SALE_REGISTRATION_DATE = STR_TO_DATE(SALE_REGISTRATION_DATE, '%Y-%m-%dT%H:%i:%s.%fZ');

-- Change the column type from text to date-time, from DDL (data definition leng)
ALTER TABLE dataset_prueba_c
MODIFY COLUMN SALE_REGISTRATION_DATE DATETIME;


-- 3. Remove/change Null values or blank values

-- First i check if there is missing information in the value fields
SELECT *
FROM dataset_prueba_c
WHERE (TRANSACTION_ID IS NULL) or (TRANSACTION_ID='') ;

SELECT *
FROM dataset_prueba_c
WHERE (ITEM_ID IS NULL) or (ITEM_ID='') ;

SELECT *
FROM dataset_prueba_c
WHERE (CURRENT_STATUS IS NULL) or (CURRENT_STATUS='') ;

SELECT *
FROM dataset_prueba_c
WHERE (CANAL_CONSOLIDADO IS NULL) or (CANAL_CONSOLIDADO='') ;

SELECT *
FROM dataset_prueba_c
WHERE (LINEA_NEGOCIO IS NULL) or (LINEA_NEGOCIO='') ;


-- As there are empty items, but with ITEM_ID, i will populate with a self-join but first I mark as null.
SELECT *
FROM dataset_prueba_c
WHERE (ITEM IS NULL) or (ITEM='') ;

UPDATE dataset_prueba_c
SET ITEM= NULL
WHERE ITEM='';
/* First i did the self-join and I found that the empty ITEMS do not have another records 
 related to the ITEM_ID with a valid value of ITEM */
SELECT *
FROM dataset_prueba_c t1
JOIN  dataset_prueba_c t2
	ON t1.ITEM_ID = t2.ITEM_ID
WHERE t1.ITEM IS NULL AND t2.ITEM IS NOT NULL;
-- I decided to call the nulls as ND
UPDATE dataset_prueba_c
SET ITEM='ND'
WHERE ITEM IS NULL;

-- I have some zero values in the TOTAL_VALUE column, i will leave as each row has the other information.
SELECT *
FROM dataset_prueba_c
WHERE (TOTAL_VALUE IS NULL) or (TOTAL_VALUE='') ;


-- 4. Remove columns and rows Unnecessary
-- Remove the row_num column that i used to clean the dupplicates
ALTER TABLE dataset_prueba_c
DROP COLUMN row_num;

SELECT *
FROM dataset_prueba_c;
SELECT *
FROM `dataset prueba`;