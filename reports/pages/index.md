# 🏙️ Airbnb São Paulo - General Overview

```sql lista_bairros
select 'All' as neighbourhood
union all
select distinct neighbourhood
from athena.neighbourhood_prices 
where neighbourhood is not null 
order by neighbourhood asc
```

<Dropdown
    name=bairro_selecionado
    data={lista_bairros}
    value=neighbourhood
    defaultValue="All"
    title="Filter by Neighborhood:"
/>


---

```sql kpis
select 
    count(*) as total_imoveis,
    round(avg(price), 2) as preco_medio,
    round(avg(review_scores_rating), 2) as nota_media
from athena.neighbourhood_prices
where ('${inputs.bairro_selecionado.value}' = 'All' or neighbourhood = '${inputs.bairro_selecionado.value}')
```

<BigValue data={kpis} value=total_imoveis title="Total Listings" agg=sum/>
<BigValue data={kpis} value=preco_medio fmt="currency-brl" title="Average Price / Night" agg=avg/>
<BigValue data={kpis} value=nota_media title="Average Rating" agg=avg/>

---


## 📈 Daily Price Distribution

The histogram helps visualize the price range where most properties in São Paulo are concentrated, reducing distortions caused by extremely high-priced luxury properties.

```sql dados_histograma
select 
    price
from athena.neighbourhood_prices
where price > 0 
  and price <= 2000
  and ('${inputs.bairro_selecionado.value}' = 'All' or neighbourhood = '${inputs.bairro_selecionado.value}')
```

<Histogram 
    data={dados_histograma} 
    x=price 
    title="Daily Price Concentration (Up to R$ 2,000)"
    fillColor="#3b82f6"
    xFmt="brl0"
/>

---

## 🎯 Correlation: Price vs. Review Rating

Do more expensive properties actually receive better guest ratings?

```sql dados_dispersao
select 
    price,
    review_scores_rating as rating,
    neighbourhood as neighborhood
from athena.neighbourhood_prices
where price > 0 
  and price <= 2000
  and review_scores_rating is not null
  and ('${inputs.bairro_selecionado.value}' = 'All' or neighbourhood = '${inputs.bairro_selecionado.value}')
```

<ScatterPlot 
    data={dados_dispersao} 
    x=price 
    y=rating 
    title="Relationship Between Daily Price and Property Rating"
    xAxisTitle="Daily Price (R$)"
    yAxisTitle="Review Rating"
    opacity=0.6
/>

----
## 📊 Distribution by Neighborhood

```sql top_bairros
select 
    neighbourhood as neighborhood,
    count(*) as total_listings,
    round(avg(price), 2) as average_price
from athena.neighbourhood_prices
where neighbourhood is not null
group by 1
order by total_listings desc
limit 10
```

<BarChart 
    data={top_bairros} 
    x=neighborhood 
    y=total_listings 
    title="Top 10 Neighborhoods by Number of Listings"
    showAllAxisLabels=true
    format="currency"
/>

<DataTable data={top_bairros} search=true pagination=true>
    <Column id=neighborhood title="Neighborhood" />
    <Column id=total_listings title="Total Listings" />
    <Column id=average_price title="Average Price" fmt="BRL" />
</DataTable>

---
