with source as (

    select * from {{ source('airbnb', 'raw_calendar') }}

),

renamed_and_casted as (

    select
        cast(listing_id as bigint) as listing_id,
        cast(nullif(trim(date), '') as date) as calendar_date,
        cast(available as boolean) as available,
        cast(minimum_nights as bigint) as minimum_nights,
        cast(maximum_nights as bigint) as maximum_nights

    from source

)

select * from renamed_and_casted
where listing_id is not null and calendar_date is not null
