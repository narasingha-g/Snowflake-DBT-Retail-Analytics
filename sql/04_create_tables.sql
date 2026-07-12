/*--Step4:Rather than creating raw tables manually, we'll let Snowflake infer the schema.using template
USE PORTFOLIO_DB;
create or replace table BRONZE.customers
using template(
select array_agg(object_construct(*))
from table(
infer_schema(
location => '@retail_stage/customers_dataset.csv',
file_format => 'csv_format'
  )
 )
);

show tables like '%customers';
select get_ddl('table','BRONZE.customers');

select * from BRONZE.customers limit 10;


-- Repeat for other datasets

create or replace table BRONZE.order_items
using template(
select array_agg(object_construct(*))
from table(
infer_schema(
location => '@retail_stage/order_items_dataset.csv',
file_format => 'csv_format'
  )
 )
);
create or replace table BRONZE.order_payments
using template(
select array_agg(object_construct(*))
from table(
infer_schema(
location => '@retail_stage/order_payments_dataset.csv',
file_format => 'csv_format'
  )
 )
);
create or replace table BRONZE.orders
using template(
select array_agg(object_construct(*))
from table(
infer_schema(
location => '@retail_stage/orders_dataset.csv',
file_format => 'csv_format'
  )
 )
);
create or replace table BRONZE.products
using template(
select array_agg(object_construct(*))
from table(
infer_schema(
location => '@retail_stage/products_dataset.csv',
file_format => 'csv_format'
  )
 )
);
create or replace table BRONZE.sellers
using template(
select array_agg(object_construct(*))
from table(
infer_schema(
location => '@retail_stage/sellers_dataset.csv',
file_format => 'csv_format'
  )
 )
);

select get_ddl('table','BRONZE.sellers');

show tables; */


-- ==========================================================
-- Script : 04_create_tables.sql
-- Purpose: Create Bronze Layer Tables
-- Project: Retail Analytics using Snowflake + dbt
-- ==========================================================

USE DATABASE PORTFOLIO_DB;
USE SCHEMA BRONZE;

-------------------------------------------------------------
-- CUSTOMERS
-------------------------------------------------------------
CREATE OR REPLACE TABLE CUSTOMERS (
    CUSTOMER_ID STRING,
    CUSTOMER_UNIQUE_ID STRING,
    CUSTOMER_ZIP_CODE_PREFIX NUMBER(5,0),
    CUSTOMER_CITY STRING,
    CUSTOMER_STATE STRING
);

-------------------------------------------------------------
-- ORDERS
-------------------------------------------------------------
CREATE OR REPLACE TABLE ORDERS (
    ORDER_ID STRING,
    CUSTOMER_ID STRING,
    ORDER_STATUS STRING,
    ORDER_PURCHASE_TIMESTAMP TIMESTAMP_NTZ,
    ORDER_APPROVED_AT TIMESTAMP_NTZ,
    ORDER_DELIVERED_CARRIER_DATE TIMESTAMP_NTZ,
    ORDER_DELIVERED_CUSTOMER_DATE TIMESTAMP_NTZ,
    ORDER_ESTIMATED_DELIVERY_DATE DATE
);

-------------------------------------------------------------
-- ORDER_ITEMS
-------------------------------------------------------------
CREATE OR REPLACE TABLE ORDER_ITEMS (
    ORDER_ID STRING,
    ORDER_ITEM_ID NUMBER(5,0),
    PRODUCT_ID STRING,
    SELLER_ID STRING,
    SHIPPING_LIMIT_DATE TIMESTAMP_NTZ,
    PRICE NUMBER(10,2),
    FREIGHT_VALUE NUMBER(10,2)
);

-------------------------------------------------------------
-- PRODUCTS
-------------------------------------------------------------
CREATE OR REPLACE TABLE PRODUCTS (
    PRODUCT_ID STRING,
    PRODUCT_CATEGORY_NAME STRING,
    PRODUCT_NAME_LENGTH NUMBER(5,0),
    PRODUCT_DESCRIPTION_LENGTH NUMBER(5,0),
    PRODUCT_PHOTOS_QTY NUMBER(5,0),
    PRODUCT_WEIGHT_G NUMBER(10,0),
    PRODUCT_LENGTH_CM NUMBER(10,0),
    PRODUCT_HEIGHT_CM NUMBER(10,0),
    PRODUCT_WIDTH_CM NUMBER(10,0)
);

-------------------------------------------------------------
-- SELLERS
-------------------------------------------------------------
CREATE OR REPLACE TABLE SELLERS (
    SELLER_ID STRING,
    SELLER_ZIP_CODE_PREFIX NUMBER(5,0),
    SELLER_CITY STRING,
    SELLER_STATE STRING
);

-------------------------------------------------------------
-- ORDER_PAYMENTS
-------------------------------------------------------------
CREATE OR REPLACE TABLE ORDER_PAYMENTS (
    ORDER_ID STRING,
    PAYMENT_SEQUENTIAL NUMBER(5,0),
    PAYMENT_TYPE STRING,
    PAYMENT_INSTALLMENTS NUMBER(5,0),
    PAYMENT_VALUE NUMBER(10,2)
);