{{ config(
    materialized='table'
) }}

SELECT

    {{ dbt_utils.generate_surrogate_key(['CUSTOMER_ID']) }}
        AS CUSTOMER_KEY,

    CUSTOMER_ID,

    CUSTOMER_CITY,

    CUSTOMER_STATE

FROM {{ ref('stg_customers') }}