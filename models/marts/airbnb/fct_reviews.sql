with stg_reviews as (

    select * from {{ ref('stg_airbnb__reviews') }}

),

final as (

    select
        review_id,
        listing_id,
        review_date,
        reviewer_id

    from stg_reviews

)

select * from final
