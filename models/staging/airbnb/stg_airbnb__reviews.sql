with source as (

    select * from {{ source('airbnb', 'raw_reviews') }}

),

renamed_and_casted as (

    select
        try_cast(id as bigint) as review_id,
        try_cast(listing_id as bigint) as listing_id,
        try_cast(nullif(date, '') as date) as review_date,
        try_cast(reviewer_id as bigint) as reviewer_id,
        reviewer_name,
        comments

    from source

)

select * from renamed_and_casted
where review_id is not null
