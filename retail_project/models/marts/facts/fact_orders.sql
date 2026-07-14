{{ config(
    materialized='incremental',
    unique_key=['ORDER_ID','ORDER_ITEM_ID'],
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

WITH order_details AS (

   SELECT
    ORDER_ID,
    ORDER_ITEM_ID,
    CUSTOMER_ID,
    PRODUCT_ID,
    SELLER_ID,
    ORDER_STATUS,
    ORDER_PURCHASE_TIMESTAMP,
    ORDER_APPROVED_AT,
    ORDER_DELIVERED_CARRIER_DATE,
    ORDER_DELIVERED_CUSTOMER_DATE,
    ORDER_ESTIMATED_DELIVERY_DATE,
    PAYMENT_TYPE,
    PAYMENT_INSTALLMENTS,
    PAYMENT_VALUE,
    PRICE,
    FREIGHT_VALUE 
  FROM {{ ref('int_order_details') }}

    {% if is_incremental() %}

        WHERE ORDER_PURCHASE_TIMESTAMP >
        (
            SELECT COALESCE(MAX(ORDER_PURCHASE_TIMESTAMP), '1900-01-01')
            FROM {{ this }}
        )

    {% endif %}

)

SELECT * FROM  order_details
