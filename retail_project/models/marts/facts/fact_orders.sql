
{{ config(
    materialized='incremental',
    unique_key=['ORDER_ID','ORDER_ITEM_ID'],
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

WITH order_details AS (

    SELECT
        ORDER_ID,
        CUSTOMER_ID,
        ORDER_STATUS,
        ORDER_PURCHASE_TIMESTAMP,
        ORDER_APPROVED_AT,
        ORDER_DELIVERED_CARRIER_DATE,
        ORDER_DELIVERED_CUSTOMER_DATE,
        ORDER_ESTIMATED_DELIVERY_DATE,
        ORDER_ITEM_ID,
        PRODUCT_ID,
        SELLER_ID,
        PRICE,
        FREIGHT_VALUE,
        PAYMENT_TYPE,
        PAYMENT_INSTALLMENTS,
        PAYMENT_VALUE
    FROM {{ ref('int_order_details') }}

    {% if is_incremental() %}

    WHERE ORDER_PURCHASE_TIMESTAMP >
    (
        SELECT COALESCE(MAX(ORDER_PURCHASE_TIMESTAMP), '1900-01-01')
        FROM {{ this }}
    )

    {% endif %}

),

customer_dimension AS (

    SELECT CUSTOMER_ID, CUSTOMER_KEY
    FROM {{ ref('dim_customers') }}

),

product_dimension AS (

    SELECT PRODUCT_ID, PRODUCT_KEY
    FROM {{ ref('dim_products') }}

),

seller_dimension AS (

    SELECT SELLER_ID, SELLER_KEY
    FROM {{ ref('dim_sellers') }}

),

date_dimension AS (

    SELECT DATE_KEY
    FROM {{ ref('dim_date') }}

)

SELECT

    od.ORDER_ID,
    od.ORDER_ITEM_ID,

    dc.CUSTOMER_KEY,
    dp.PRODUCT_KEY,
    ds.SELLER_KEY,
    dd.DATE_KEY,

    od.ORDER_STATUS,

    od.ORDER_PURCHASE_TIMESTAMP,
    od.ORDER_APPROVED_AT,
    od.ORDER_DELIVERED_CARRIER_DATE,
    od.ORDER_DELIVERED_CUSTOMER_DATE,
    od.ORDER_ESTIMATED_DELIVERY_DATE,

    od.PAYMENT_TYPE,
    od.PAYMENT_INSTALLMENTS,
    od.PAYMENT_VALUE,

    od.PRICE,
    od.FREIGHT_VALUE,
-- Total Revenue
(od.PRICE + od.FREIGHT_VALUE) AS TOTAL_ITEM_AMOUNT,

-- Shipping %
ROUND(
    (od.FREIGHT_VALUE / NULLIF(od.PRICE,0))*100,
    2
) AS FREIGHT_PERCENTAGE,

-- Purchase Year
YEAR(od.ORDER_PURCHASE_TIMESTAMP) AS PURCHASE_YEAR,

-- Purchase Month
MONTH(od.ORDER_PURCHASE_TIMESTAMP) AS PURCHASE_MONTH,

-- Purchase Quarter
QUARTER(od.ORDER_PURCHASE_TIMESTAMP) AS PURCHASE_QUARTER,

-- Purchase Week
WEEK(od.ORDER_PURCHASE_TIMESTAMP) AS PURCHASE_WEEK,

-- Purchase Day
DAY(od.ORDER_PURCHASE_TIMESTAMP) AS PURCHASE_DAY,

-- Delivery Days
DATEDIFF(
    'day',
    od.ORDER_PURCHASE_TIMESTAMP,
    od.ORDER_DELIVERED_CUSTOMER_DATE
) AS DELIVERY_DAYS,

-- Estimated Delivery Days
DATEDIFF(
    'day',
    od.ORDER_PURCHASE_TIMESTAMP,
    od.ORDER_ESTIMATED_DELIVERY_DATE
) AS ESTIMATED_DELIVERY_DAYS,

-- Delivery Delay
DATEDIFF(
    'day',
    od.ORDER_ESTIMATED_DELIVERY_DATE,
    od.ORDER_DELIVERED_CUSTOMER_DATE
) AS DELIVERY_DELAY_DAYS,

-- High Value Order
CASE
    WHEN od.PRICE >= 500 THEN TRUE
    ELSE FALSE
END AS HIGH_VALUE_ORDER,

-- Late Delivery Flag
CASE
    WHEN od.ORDER_DELIVERED_CUSTOMER_DATE >
         od.ORDER_ESTIMATED_DELIVERY_DATE
    THEN TRUE
    ELSE FALSE
END AS LATE_DELIVERY 

FROM order_details od

LEFT JOIN customer_dimension dc
    ON od.CUSTOMER_ID = dc.CUSTOMER_ID

LEFT JOIN product_dimension dp
    ON od.PRODUCT_ID = dp.PRODUCT_ID

LEFT JOIN seller_dimension ds
    ON od.SELLER_ID = ds.SELLER_ID

LEFT JOIN date_dimension dd
    ON CAST(od.ORDER_PURCHASE_TIMESTAMP AS DATE) = dd.DATE_KEY