{% macro create_databases() %}

    {% set databases = ['bronze', 'silver', 'gold'] %}

    {% for db in databases %}
        {% set sql %}
            CREATE DATABASE IF NOT EXISTS {{ db }};
        {% endset %}

        {% do run_query(sql) %}
        {% do log("Banco de dados '" ~ db ~ "' garantido no Athena!", info=True) %}
    {% endfor %}

{% endmacro %}
