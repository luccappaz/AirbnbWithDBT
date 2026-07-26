# 🏡 Airbnb Analytics Platform

### Data Lakehouse + dbt + Athena + Evidence.dev + Vercel

An end-to-end analytics platform that transforms Airbnb listings into a modern data warehouse and interactive dashboard using AWS, dbt, and BI-as-code.

![Python](https://img.shields.io/badge/Python-3.9+-3776AB?logo=python&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-Analytics%20Engineering-FF694B?logo=dbt&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Athena%20%7C%20Glue%20%7C%20S3-232F3E?logo=amazonaws&logoColor=white)
![DuckDB](https://img.shields.io/badge/DuckDB-Analytics-FFF000?logo=duckdb&logoColor=black)
![Evidence](https://img.shields.io/badge/Evidence.dev-BI--as--Code-6E56CF)
![Vercel](https://img.shields.io/badge/Vercel-Deployment-000000?logo=vercel&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

![AirbnbLayout](assets/AirbnbLayout.png)

## Demo

![Dashboard Demo](assets/dashboard-demo.png)
---

## About

This project builds a complete analytics pipeline for Airbnb listings in São Paulo.

Raw datasets are stored in Amazon S3, transformed with dbt following the Medallion Architecture, queried through Amazon Athena, and visualized using Evidence.dev. The final dashboard is deployed as a static website on Vercel.

---

## Motivation

Understanding Airbnb pricing trends requires more than simply querying raw CSV files.

This project demonstrates how modern Data Engineering practices can be applied to build a scalable analytics platform by combining:

- Medallion Architecture
- Dimensional Modeling
- Data Quality with dbt
- Serverless Analytics with Athena
- BI-as-Code with Evidence.dev

The final result is an interactive dashboard capable of exploring prices, neighborhoods, and review scores with low latency and minimal cloud costs.

---

## Features

- End-to-end analytics pipeline
- Medallion Architecture (Bronze, Silver, Gold)
- Data modeling with dbt
- Data quality tests
- Amazon Athena integration
- DuckDB local caching
- Interactive dashboard with Evidence.dev
- Static deployment on Vercel
- BI-as-Code approach

---

## Technical Highlights

### 🏅 Medallion Architecture

The project follows the Medallion Architecture:

- **Bronze:** raw CSV/Parquet files stored in Amazon S3.
- **Silver:** cleaned and standardized datasets with proper data types.
- **Gold:** dimensional models optimized for business analytics.

### 🔧 Data Modeling with dbt

dbt is responsible for:

- Cleaning price values
- Removing special characters
- Data type enforcement
- Integrity tests
- Dimensional modeling

### ⚡ Efficient Queries with DuckDB

Evidence.dev queries Amazon Athena only once to retrieve aggregated datasets.

The data is cached locally in DuckDB using:

```bash
npm run sources
```

This dramatically reduces AWS query costs while allowing millisecond dashboard performance.

### 🌐 Static Deployment

Evidence.dev generates static pages that are deployed on Vercel while still supporting interactive components such as:

- BigValue
- Histograms
- Scatter Plots
- Dropdown Filters

---

## Technology Stack

| Technology | Purpose |
|------------|----------|
| Amazon S3 | Raw data storage |
| AWS Glue Data Catalog | Metadata catalog |
| Amazon Athena | Serverless SQL engine |
| dbt (dbt-athena-community) | Data transformation |
| SQL | Data modeling |
| DuckDB | Local analytical cache |
| Evidence.dev | BI-as-Code dashboard |
| Svelte | Frontend framework |
| Vercel | Static deployment |

---

## Project Structure

```mermaid
graph TD
    Root[airbnb/]
    
    Root --> Analyses[analyses/]
      Analyses --> finding_empty_raw_columns.sql 
      
    Root --> Macros[macros/]
      Macros --> create_database.sql
      Macros --> create_raw_table.sql
      
    Root --> Model[models/]
      Model --> Staging[models/staging/]
        Staging --> Silver[models/staging/airbnb/]
          Silver --> stg_airbnb__listings.sql
          Silver --> stg_airbnb__reviews.sql
          Silver --> stg_airbnb__calendar.sql
          Silver --> stg_airbnb__listing_amenities.sql
          
      Model --> Marts[models/marts/]
        Marts --> Gold[models/marts/airbnb/]
          Gold --> dim_listings.sql
    
    Root --> Reports[reports/]
    Root --> dbt_project.yml
    Root --> package.yml
    Root --> README.md

    subgraph Reports
            Pages[reports/pages] --> index.md[pages/index.md] 
            Sources[reports/sources] --> Athena[sources/athena]
            Athena --> Connection[athena/connection.yaml]
            Athena --> NeighbourhoodPrices[athena/neighbourhood_prices.sql]
        end

```
### Data Pipeline
 ```mermaid
 flowchart LR
     %% Fontes de Origem
     subgraph Sources[" 📥 Fonte de Dados "]
         A["Inside Airbnb - SP<br/>(CSVs de Anúncios e Diárias)"]
     end
 
     %% Arquitetura Medalhão na AWS
     subgraph Medallion[" 🏅 Arquitetura Medalhão (AWS) "]
         Bronze["🥉 Bronze Layer (S3 Raw)<br/>Arquivos CSV/Parquet Brutos"]
         Silver["🥈 Silver Layer (dbt / Athena)<br/>Tratamento de Preços, Nulos e Tipagem"]
         Gold["🥇 Gold Layer (lucca_gold)<br/>dim_listings / fct_listings_daily/ neighbourhood_perfomance"]
     end
 
     %% Processamento Local do Evidence
     subgraph EvidenceEngine[" ⚡ Camada do Evidence.dev "]
         AthenaQueries["sources/athena/*.sql<br/>Queries Selecionadas e Filtradas"]
         DuckDB["Cache Local (DuckDB)<br/>npm run sources"]
     end
 
     %% Consumo & Hospedagem
     subgraph Destinations[" 📊 Consumo & Publicação "]
         Dashboard["Dashboard Interativo (index.md)<br/>BigValues, BarChart, Hist, ScatterPlot"]
         Deploy["Deploy Estático (SSG)<br/>Vercel / Netlify"]
     end
 
     %% Fluxo de Dados
     Sources -->|Ingestão S3| Bronze
     Bronze -->|Limpeza & Regex de Cifrão| Silver
     Silver -->|Modelagem Dimensional| Gold
     Gold -->|Execução de Queries| AthenaQueries
     AthenaQueries -->|Download mínimo de colunas| DuckDB
     DuckDB -->|Alimenta Gráficos Localmente| Dashboard
     Dashboard -->|npm run build| Deploy
 
     %% Estilização das Camadas
     style Bronze fill:#cd7f32,stroke:#663300,stroke-width:2px,color:#fff
     style Silver fill:#c0c0c0,stroke:#4a4a4a,stroke-width:2px,color:#000
     style Gold fill:#ffd700,stroke:#8b6508,stroke-width:2px,color:#000
     style DuckDB fill:#fff7d6,stroke:#d9a700,stroke-width:2px,color:#000
     style Dashboard fill:#e6f0ff,stroke:#2563eb,stroke-width:2px,color:#000
     style Deploy fill:#111827,stroke:#374151,stroke-width:2px,color:#fff
     
 ```
## Quick Start

### Prerequisites

- Python 3.9+
- Node.js 18+
- AWS CLI configured
- dbt-athena-community

### Configure AWS Credentials

```bash
aws configure
```

---

### Run dbt Models

```bash
python3 -m venv .venv

source .venv/bin/activate

pip install dbt-athena-community

dbt deps

dbt run
```

---

### Launch the Dashboard

```bash
cd reports

npm install

npm run sources

npm run dev
```

Open:

```
http://localhost:3000
```

---

### Production Build

```bash
npm run build

npm run preview
```

---

## Dashboard

### Home

(screenshot)

### Price Distribution

(screenshot)

### Neighborhood Analysis

(screenshot)

---

## Dataset

This project uses the São Paulo Airbnb dataset provided by Inside Airbnb.

https://insideairbnb.com/

---

## Roadmap

- [x] Bronze layer
- [x] Silver transformations
- [x] Gold dimensional models
- [x] dbt data quality tests
- [x] Athena integration
- [x] DuckDB local cache
- [x] Evidence.dev dashboard
- [x] Vercel deployment
- [ ] Incremental dbt models
- [ ] CI/CD with GitHub Actions
- [ ] Dockerized local environment
- [ ] Scheduled dbt jobs
- [ ] Dashboard authentication

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
