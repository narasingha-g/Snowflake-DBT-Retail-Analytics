SELECT *
FROM {{ ref('fact_orders') }}
WHERE PRODUCT_KEY IS NOT NULL