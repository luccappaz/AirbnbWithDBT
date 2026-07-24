with dim_listings as (

    select * from {{ ref('dim_listings') }}

),

final as (

    select
        neighbourhood,
        room_type,
        count(listing_id) as total_listings,
        round(avg(price), 2) as avg_price,
        round(min(price), 2) as min_price,
        round(max(price), 2) as max_price,
        round(avg(review_scores_rating), 2) as avg_rating,
        sum(number_of_reviews) as total_reviews,
        round(avg(accommodates), 1) as avg_accommodates,
        round(avg(total_amenities), 1) as avg_amenities

    from dim_listings
    group by 1, 2

)

select * from final
