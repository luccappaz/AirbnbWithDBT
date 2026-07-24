with stg_calendar as (

    select * from {{ ref('stg_airbnb__calendar') }}

),

final as (

    select
        listing_id,
        calendar_date,
        available,
        minimum_nights,
        maximum_nights

    from stg_calendar

)

select * from final
