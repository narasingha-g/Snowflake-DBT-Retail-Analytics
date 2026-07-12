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

    (oi.PRICE + oi.FREIGHT_VALUE) AS TOTAL_ITEM_AMOUNT,

    -- Payment Information
    op.PAYMENT_TYPE,
    op.PAYMENT_INSTALLMENTS,
    op.PAYMENT_VALUE,

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

FROM {{ ref('stg_orders') }} o

LEFT JOIN {{ ref('stg_order_items') }} oi
       ON o.ORDER_ID = oi.ORDER_ID

LEFT JOIN {{ ref('stg_order_payments') }} op
       ON o.ORDER_ID = op.ORDER_ID

LEFT JOIN {{ ref('stg_customers') }} c
       ON o.CUSTOMER_ID = c.CUSTOMER_ID

LEFT JOIN {{ ref('stg_products') }} p
       ON oi.PRODUCT_ID = p.PRODUCT_ID

LEFT JOIN {{ ref('stg_sellers') }} s
       ON oi.SELLER_ID = s.SELLER_ID