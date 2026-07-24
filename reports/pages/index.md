# 🏙️ Airbnb São Paulo - Panorama Geral

```sql lista_bairros
select 'Todos' as neighbourhood
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
    title="Filtrar por Bairro:"
/>


---

```sql kpis
select 
    count(*) as total_imoveis,
    round(avg(price), 2) as preco_medio,
    round(avg(review_scores_rating), 2) as nota_media
from athena.neighbourhood_prices
where ('${inputs.bairro_selecionado.value}' = 'Todos' or neighbourhood = '${inputs.bairro_selecionado.value}')
```

<BigValue data={kpis} value=total_imoveis title="Total de Imóveis" agg=sum/>
<BigValue data={kpis} value=preco_medio fmt="currency-brl" title="Preço Médio / Noite" agg=avg/>
<BigValue data={kpis} value=nota_media title="Nota Média" agg=avg/>

---


## 📈 Distribuição de Preços das Diárias

O histograma ajuda a visualizar em qual faixa se concentra a maior parte dos imóveis em São Paulo, ignorando distorções de médias causadas por imóveis de altíssimo luxo.

```sql dados_histograma
select 
    price
from athena.neighbourhood_prices
where price > 0 
  and price <= 2000
  and ('${inputs.bairro_selecionado.value}' = 'Todos' or neighbourhood = '${inputs.bairro_selecionado.value}')
```

<Histogram 
    data={dados_histograma} 
    x=price 
    title="Concentração de Preços de Diárias (Até R$ 2.000)"
    fillColor="#3b82f6"
    xFmt="brl0"
/>

---

## 🎯 Correlação: Preço vs. Nota de Avaliação

Será que os imóveis com diárias mais caras realmente recebem as melhores avaliações dos hóspedes?

```sql dados_dispersao
select 
    price,
    review_scores_rating as nota,
    neighbourhood as bairro
from athena.neighbourhood_prices
where price > 0 
  and price <= 2000
  and review_scores_rating is not null
  and ('${inputs.bairro_selecionado.value}' = 'Todos' or neighbourhood = '${inputs.bairro_selecionado.value}')
```

<ScatterPlot 
    data={dados_dispersao} 
    x=price 
    y=nota 
    title="Relação entre Preço da Diária e Nota do Imóvel"
    xAxisTitle="Preço da Diária (R$)"
    yAxisTitle="Nota de Avaliação"
    opacity=0.6
/>

----
## 📊 Distribuição por Bairro

```sql top_bairros
select 
    neighbourhood as bairro,
    count(*) as total_anuncios,
    round(avg(price), 2) as preco_medio
from athena.neighbourhood_prices
where neighbourhood is not null
group by 1
order by total_anuncios desc
limit 10
```

<BarChart 
    data={top_bairros} 
    x=bairro 
    y=total_anuncios 
    title="Top 10 Bairros com Mais Anúncios"
    showAllAxisLabels=true
/>

<DataTable data={top_bairros} search=true pagination=true>
    <Column id=bairro title="Bairro" />
    <Column id=total_anuncios title="Total Imóveis" />
    <Column id=preco_medio title="Média de Preço" fmt=currency-brl />
</DataTable>

---
