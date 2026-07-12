USE PORTFOLIO_DB;


-------------------------------------------------------------
-- LOAD CUSTOMERS
-------------------------------------------------------------
COPY INTO BRONZE.CUSTOMERS
FROM @RETAIL_STAGE/customers_dataset.csv
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
-------------------------------------------------------------
-- LOAD ORDERS
-------------------------------------------------------------
COPY INTO BRONZE.ORDERS
FROM @RETAIL_STAGE/orders_dataset.csv
FILE_FORMAT = (FORMAT_NAME='CSV_FORMAT')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
-------------------------------------------------------------
-- LOAD ORDER_ITEMS
-------------------------------------------------------------
COPY INTO BRONZE.ORDER_ITEMS
FROM @RETAIL_STAGE/order_items_dataset.csv
FILE_FORMAT = (FORMAT_NAME='CSV_FORMAT')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
-------------------------------------------------------------
-- LOAD ORDER_PAYMENTS
-------------------------------------------------------------
COPY INTO BRONZE.ORDER_PAYMENTS
FROM @RETAIL_STAGE/order_payments_dataset.csv
FILE_FORMAT = (FORMAT_NAME='CSV_FORMAT')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-------------------------------------------------------------
-- LOAD PRODUCTS
-------------------------------------------------------------
COPY INTO BRONZE.PRODUCTS
FROM @RETAIL_STAGE/products_dataset.csv
FILE_FORMAT = (FORMAT_NAME='CSV_FORMAT')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-------------------------------------------------------------
-- LOAD SELLERS
-------------------------------------------------------------
COPY INTO BRONZE.SELLERS
FROM @RETAIL_STAGE/sellers_dataset.csv
FILE_FORMAT = (FORMAT_NAME='CSV_FORMAT')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

SHOW TABLES IN PORTFOLIO_DB.BRONZE;