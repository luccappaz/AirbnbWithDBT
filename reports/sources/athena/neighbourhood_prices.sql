select
    neighbourhood,
    cast(price as double) as price,
    review_scores_rating
from lucca_gold.dim_listings
where neighbourhood is not null
