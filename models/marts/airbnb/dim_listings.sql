with stg_listings as (

    select * from {{ ref('stg_airbnb__listings') }}

),

final as (

    select
        id as listing_id,
        name as listing_name,
        property_type,
        room_type,
        accommodates,
        bedrooms,
        beds,
        bathrooms,
        neighbourhood_cleansed as neighbourhood,
        latitude,
        longitude,
        price,
        total_amenities,
        review_scores_rating,
        number_of_reviews

    from stg_listings

)

select * from final
where neighbourhood is not null
      and room_type is not null
      and latitude is not null
      and longitude is not null
      and price is not null
