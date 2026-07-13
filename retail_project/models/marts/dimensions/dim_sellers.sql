{{ config(
    materialized='table'
) }}

SELECT

    {{ dbt_utils.generate_surrogate_key(['SELLER_ID']) }}
        AS SELLER_KEY,

    SELLER_ID,

    SELLER_CITY,

    SELLER_STATE

FROM {{ ref('stg_sellers') }}