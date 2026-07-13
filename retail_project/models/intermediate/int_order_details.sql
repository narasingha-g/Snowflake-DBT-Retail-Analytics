WITH

orders AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

),

order_items AS (

    SELECT *
    FROM {{ ref('stg_order_items') }}

),

payment_summary AS (

    SELECT
        ORDER_ID,
        SUM(PAYMENT_VALUE) AS PAYMENT_VALUE,
        MAX(PAYMENT_TYPE) AS PAYMENT_TYPE,
        MAX(PAYMENT_INSTALLMENTS) AS PAYMENT_INSTALLMENTS
    FROM {{ ref('stg_order_payments') }}
    GROUP BY ORDER_ID

),

customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

products AS (

    SELECT *
    FROM {{ ref('stg_products') }}

),

sellers AS (

    SELECT *
    FROM {{ ref('stg_sellers') }}

)

SELECT
-- Order Information 
o.ORDER_ID,
o.CUSTOMER_ID,
o.ORDER_STATUS,
o.ORDER_PURCHASE_TIMESTAMP,
o.ORDER_APPROVED_AT,
o.ORDER_DELIVERED_CARRIER_DATE,
o.ORDER_DELIVERED_CUSTOMER_DATE,
o.ORDER_ESTIMATED_DELIVERY_DATE,
-- Item Information
oi.ORDER_ITEM_ID,
oi.PRODUCT_ID,
oi.SELLER_ID,
oi.PRICE,
oi.FREIGHT_VALUE,
-- Payment Information
ps.PAYMENT_TYPE,
ps.PAYMENT_INSTALLMENTS,
ps.PAYMENT_VALUE,
-- Customer Information
c.CUSTOMER_CITY,
c.CUSTOMER_STATE,
-- Seller Information
s.SELLER_CITY,
s.SELLER_STATE,
-- Product Information
p.PRODUCT_CATEGORY_NAME,
p.PRODUCT_WEIGHT_G,
p.PRODUCT_LENGTH_CM,
p.PRODUCT_WIDTH_CM,
p.PRODUCT_HEIGHT_CM 

FROM orders o

LEFT JOIN order_items oi
       ON o.ORDER_ID = oi.ORDER_ID

LEFT JOIN payment_summary ps
       ON o.ORDER_ID = ps.ORDER_ID

LEFT JOIN customers c
       ON o.CUSTOMER_ID = c.CUSTOMER_ID

LEFT JOIN products p
       ON oi.PRODUCT_ID = p.PRODUCT_ID

LEFT JOIN sellers s
       ON oi.SELLER_ID = s.SELLER_ID