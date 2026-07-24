with source as (
    select * from {{ source('airbnb', 'raw_listings') }}
),

parsed as (
    select
        try_cast(id as bigint) as listing_id,
        -- Converte para um array nativo do Athena
        try(cast(json_parse(amenities) as array(varchar))) as amenities_array
from source
where amenities is not null and amenities != ''
)

select
    listing_id,
    trim(amenity) as amenity_name
from parsed
cross join unnest(amenities_array) as t(amenity)
where trim(amenity) != ''
