{{ config(
    materialized='incremental',
    unique_key='chunk_id'
) }}

select
    franchiseID as franchise_id,
    review_date,
    chunked_text,
    chunk_id,
    review_uri

from {{ source('default', 'san_test') }}

{% if is_incremental() %}

where review_date > (
    select coalesce(max(review_date), '1900-01-01')
    from {{ this }}
)

{% endif %}
