{% set relation = source('airbnb', 'raw_listings') %}
{% set columns = adapter.get_columns_in_relation(relation) %}

with summary as (
    select
        count(*) as total_rows,
        map(
            array[
                {% for col in columns %}
                '{{ col.name }}'{% if not loop.last %},{% endif %}
                {% endfor %}
            ],
            array[
                {% for col in columns %}
                count(case when {{ adapter.quote(col.name) }} is not null and cast({{ adapter.quote(col.name) }} as varchar) not in ('', 'None', 'null', 'NULL', 'nan') then 1 end){% if not loop.last %},{% endif %}
                {% endfor %}
            ]
        ) as column_counts
    from {{ relation }}
)

select
    column_name,
    non_null_count,
    round(cast(non_null_count as double) / total_rows * 100, 2) as pct_preenchido
from summary
cross join unnest(column_counts) as t(column_name, non_null_count)
order by pct_preenchido asc
