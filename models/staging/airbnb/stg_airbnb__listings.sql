with source as (

    select * from {{ source('airbnb', 'raw_listings') }}

),

renamed_and_casted as (

    select
        -- Identificadores e URLs
        try_cast(id as bigint) as id,
        listing_url,
        try_cast(scrape_id as bigint) as scrape_id,
        try_cast(nullif(last_scraped, '') as date) as last_scraped,
        source,

        -- Descrições
        name,
        description,
        neighborhood_overview,
        picture_url,

        -- Informações do Host
        try_cast(host_id as bigint) as host_id,
        host_url,
        try_cast(host_profile_id as bigint) as host_profile_id,
        host_profile_url,
        host_name,
        try_cast(hosts_time_as_user_years as bigint) as hosts_time_as_user_years,
        try_cast(hosts_time_as_user_months as bigint) as hosts_time_as_user_months,
        try_cast(hosts_time_as_host_years as bigint) as hosts_time_as_host_years,
        try_cast(hosts_time_as_host_months as bigint) as hosts_time_as_host_months,
        host_location,
        host_about,
        try_cast(host_is_superhost as boolean) as host_is_superhost,
        host_picture_url,
        try_cast(host_listings_count as bigint) as host_listings_count,
        try_cast(host_has_profile_pic as boolean) as host_has_profile_pic,
        try_cast(host_identity_verified as boolean) as host_identity_verified,

        -- Localização e Atributos
        neighbourhood_cleansed,
        neighbourhood_group_cleansed,
        try_cast(latitude as double) as latitude,
        try_cast(longitude as double) as longitude,
        property_type,
        room_type,
        try_cast(accommodates as bigint) as accommodates,
        try_cast(bathrooms as double) as bathrooms,
        bathrooms_text,
        try_cast(bedrooms as bigint) as bedrooms,
        try_cast(beds as bigint) as beds,
        cardinality(try(cast(json_parse(amenities) as array(varchar)))) as total_amenities,

        -- Preços e Regras
        try_cast(regexp_replace(price, '[\$,]', '') as decimal(10,2)) as price,
        try_cast(nullif(price_quote_checkin_date, '') as date) as price_quote_checkin_date,
        try_cast(nullif(price_quote_checkout_date, '') as date) as price_quote_checkout_date,
        try_cast(price_quote_total_price as double) as price_quote_total_price,
        try_cast(price_quote_price_per_night as double) as price_quote_price_per_night,
        try(cast(json_extract_scalar(price_quote_raw, '$.quote.discount_amount') as decimal(10,2))) as quote_discount_amount,
        try(json_extract_scalar(price_quote_raw, '$.quote.currency')) as quote_currency,
        try_cast(minimum_nights as bigint) as minimum_nights,
        try_cast(maximum_nights as bigint) as maximum_nights,
        try_cast(minimum_minimum_nights as bigint) as minimum_minimum_nights,
        try_cast(maximum_minimum_nights as bigint) as maximum_minimum_nights,
        try_cast(minimum_maximum_nights as bigint) as minimum_maximum_nights,
        try_cast(maximum_maximum_nights as bigint) as maximum_maximum_nights,
        try_cast(minimum_nights_avg_ntm as double) as minimum_nights_avg_ntm,
        try_cast(maximum_nights_avg_ntm as double) as maximum_nights_avg_ntm,

        -- Disponibilidade e Histórico
        try_cast(has_availability as boolean) as has_availability,
        try_cast(availability_30 as bigint) as availability_30,
        try_cast(availability_60 as bigint) as availability_60,
        try_cast(availability_90 as bigint) as availability_90,
        try_cast(availability_365 as bigint) as availability_365,
        try_cast(nullif(calendar_last_scraped, '') as date) as calendar_last_scraped,
        try_cast(number_of_reviews as bigint) as number_of_reviews,
        try_cast(number_of_reviews_ltm as bigint) as number_of_reviews_ltm,
        try_cast(number_of_reviews_l30d as bigint) as number_of_reviews_l30d,
        try_cast(availability_eoy as bigint) as availability_eoy,
        try_cast(number_of_reviews_ly as bigint) as number_of_reviews_ly,
        try_cast(estimated_occupancy_l365d as bigint) as estimated_occupancy_l365d,
        try_cast(estimated_revenue_l365d as bigint) as estimated_revenue_l365d,
        try_cast(nullif(first_review, '') as date) as first_review,
        try_cast(nullif(last_review, '') as date) as last_review,

        -- Avaliações
        try_cast(review_scores_rating as double) as review_scores_rating,
        try_cast(review_scores_accuracy as double) as review_scores_accuracy,
        try_cast(review_scores_cleanliness as double) as review_scores_cleanliness,
        try_cast(review_scores_checkin as double) as review_scores_checkin,
        try_cast(review_scores_communication as double) as review_scores_communication,
        try_cast(review_scores_location as double) as review_scores_location,
        try_cast(review_scores_value as double) as review_scores_value,
        try_cast(calculated_host_listings_count as bigint) as calculated_host_listings_count,
        try_cast(calculated_host_listings_count_entire_homes as bigint) as calculated_host_listings_count_entire_homes,
        try_cast(calculated_host_listings_count_private_rooms as bigint) as calculated_host_listings_count_private_rooms,
        try_cast(calculated_host_listings_count_shared_rooms as bigint) as calculated_host_listings_count_shared_rooms,
        try_cast(reviews_per_month as double) as reviews_per_month

    from source

)

select * from renamed_and_casted
where id is not null
