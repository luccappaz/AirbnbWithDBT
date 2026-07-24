{% macro create_raw_tables() %}

    {% set sql_raw_listings %}
        CREATE EXTERNAL TABLE IF NOT EXISTS bronze.raw_listings (
            id string,
            listing_url string,
            scrape_id string,
            last_scraped string,
            source string,
            name string,
            description string,
            neighborhood_overview string,
            picture_url string,
            host_id string,
            host_url string,
            host_profile_id string,
            host_profile_url string,
            host_name string,
            host_since string,
            hosts_time_as_user_years string,
            hosts_time_as_user_months string,
            hosts_time_as_host_years string,
            hosts_time_as_host_months string,
            host_location string,
            host_about string,
            host_response_time string,
            host_response_rate string,
            host_acceptance_rate string,
            host_is_superhost string,
            host_thumbnail_url string,
            host_picture_url string,
            host_neighbourhood string,
            host_listings_count string,
            host_total_listings_count string,
            host_verifications string,
            host_has_profile_pic string,
            host_identity_verified string,
            neighbourhood string,
            neighbourhood_cleansed string,
            neighbourhood_group_cleansed string,
            latitude string,
            longitude string,
            property_type string,
            room_type string,
            accommodates string,
            bathrooms string,
            bathrooms_text string,
            bedrooms string,
            beds string,
            amenities string,
            price string,
            price_quote_checkin_date string,
            price_quote_checkout_date string,
            price_quote_total_price string,
            price_quote_price_per_night string,
            price_quote_raw string,
            minimum_nights string,
            maximum_nights string,
            minimum_minimum_nights string,
            maximum_minimum_nights string,
            minimum_maximum_nights string,
            maximum_maximum_nights string,
            minimum_nights_avg_ntm string,
            maximum_nights_avg_ntm string,
            calendar_updated string,
            has_availability string,
            availability_30 string,
            availability_60 string,
            availability_90 string,
            availability_365 string,
            calendar_last_scraped string,
            number_of_reviews string,
            number_of_reviews_ltm string,
            number_of_reviews_l30d string,
            availability_eoy string,
            number_of_reviews_ly string,
            estimated_occupancy_l365d string,
            estimated_revenue_l365d string,
            first_review string,
            last_review string,
            review_scores_rating string,
            review_scores_accuracy string,
            review_scores_cleanliness string,
            review_scores_checkin string,
            review_scores_communication string,
            review_scores_location string,
            review_scores_value string,
            license string,
            instant_bookable string,
            calculated_host_listings_count string,
            calculated_host_listings_count_entire_homes string,
            calculated_host_listings_count_private_rooms string,
            calculated_host_listings_count_shared_rooms string,
            reviews_per_month string
        )
        ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
        WITH SERDEPROPERTIES (
           "separatorChar" = ",",
           "quoteChar"     = "\""
        )
        LOCATION 's3://airbnb-lucca/raw/listings/'
        TBLPROPERTIES ('skip.header.line.count'='1');
    {% endset %}

    {% set sql_raw_reviews %}
            CREATE EXTERNAL TABLE IF NOT EXISTS bronze.raw_reviews (
                listing_id string,
                id string,
                date string,
                reviewer_id string,
                reviewer_name string,
                comments string
            )
            ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
            WITH SERDEPROPERTIES (
               "separatorChar" = ",",
               "quoteChar"     = "\""
            )
            LOCATION 's3://airbnb-lucca/raw/reviews/'
            TBLPROPERTIES ('skip.header.line.count'='1');
    {% endset %}

    {% set sql_raw_calendar %}
            CREATE EXTERNAL TABLE IF NOT EXISTS bronze.raw_calendar (
                listing_id string,
                date string,
                available string,
                minimum_nights string,
                maximum_nights string
            )
            ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
            WITH SERDEPROPERTIES (
               "separatorChar" = ",",
               "quoteChar"     = "\""
            )
            LOCATION 's3://airbnb-lucca/raw/calendar/'
            TBLPROPERTIES ('skip.header.line.count'='1');
    {% endset %}

    {% do run_query(sql_raw_listings) %}
    {% do log("Tabela bronze.raw_listings criada com sucesso no Athena via dbt!", info=True) %}

    {% do run_query(sql_raw_reviews) %}
    {% do log("Tabela bronze.raw_reviews criada com sucesso no Athena via dbt!", info=True) %}

    {% do run_query(sql_raw_calendar) %}
    {% do log("Tabela bronze.raw_calendar criada com sucesso no Athena via dbt!", info=True) %}

{% endmacro %}
