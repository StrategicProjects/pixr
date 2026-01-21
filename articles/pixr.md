# Introduction to pixr

## Overview

The **pixr** package provides a tidyverse-style interface to the
Brazilian Central Bank (BCB) PIX Open Data API. PIX is Brazil’s instant
payment system, launched in November 2020, which has become the
country’s primary payment method with over 150 million active users.

This package allows you to retrieve:

- **PIX Keys Stock**: Monthly statistics on registered PIX keys by
  financial institution
- **Transactions by Municipality**: PIX transaction volumes aggregated
  by Brazilian municipalities
- **Transaction Statistics**: Detailed PIX transaction breakdowns by
  type, region, and demographics
- **Fraud Statistics**: PIX fraud data from the Special Return Mechanism
  (MED)

## Installation

You can install pixr from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("StrategicProjects/pixr")
```

## Getting Started

Load the package:

``` r
library(pixr)
```

### API Endpoints

Each endpoint requires a specific date parameter:

| Endpoint                  | Parameter  | Format     | R Function                                                                                                                         |
|---------------------------|------------|------------|------------------------------------------------------------------------------------------------------------------------------------|
| ChavesPix                 | `date`     | YYYY-MM-DD | [`get_pix_keys()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_keys.md)                                                 |
| TransacoesPixPorMunicipio | `database` | YYYYMM     | [`get_pix_transactions_by_municipality()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_municipality.md) |
| EstatisticasTransacoesPix | `database` | YYYYMM     | [`get_pix_transaction_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transaction_stats.md)                       |
| EstatisticasFraudesPix    | `database` | YYYYMM     | [`get_pix_fraud_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_fraud_stats.md)                                   |

``` r
# List all available endpoints
pix_endpoints()

# Get column information for each endpoint
pix_columns("keys")
pix_columns("municipality")
pix_columns("stats")
```

## Quick Examples

### Retrieve PIX Keys Data

PIX keys are identifiers used to simplify instant payments. Users can
register up to 5 keys (individuals) or 20 keys (companies) per account.
Key types include:

- **CPF**: Individual taxpayer ID
- **CNPJ**: Company taxpayer ID
- **Celular**: Mobile phone number
- **e-mail**: Email address
- **Aleatória (EVP)**: Randomly generated unique identifier

``` r
# Get all PIX keys data for December 2025
# Note: date uses YYYY-MM-DD format
keys <- get_pix_keys(date = "2025-12-01")

# Filter by key type
cpf_keys <- get_pix_keys(
  date = "2025-12-01",
  filter = "TipoChave eq 'CPF'",
  orderby = "qtdChaves desc",
  top = 100
)

# Get summary by institution
get_pix_keys_summary(date = "2025-12-01", n_top = 20)
```

### Retrieve Transaction Data by Municipality

``` r
# Get transactions for December 2025
# Note: database uses YYYYMM format
muni <- get_pix_transactions_by_municipality(database = "202512")

# Filter by state using OData filter
maranhao <- get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Estado eq 'MARANHÃO'",
  orderby = "Municipio desc",
  top = 10
)

# Aggregate by state
state_summary <- get_pix_transactions_by_state(database = "202512")

# Aggregate by region
region_summary <- get_pix_transactions_by_region(database = "202512")
```

### Retrieve Transaction Statistics

``` r
# Get detailed transaction statistics for September 2025
stats <- get_pix_transaction_stats(database = "202509")

# Filter by transaction nature (P2P, P2B, etc.)
p2p <- get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P'"
)

# Get summary by transaction nature
get_pix_summary(database = "202509", group_by = "NATUREZA")

# Get summary by region
get_pix_summary(database = "202509", group_by = "PAG_REGIAO")

# Get data for multiple months
q3_data <- get_pix_transaction_stats_multi(
  databases = c("202507", "202508", "202509")
)
```

### Retrieve Fraud Statistics

``` r
# Get fraud statistics (MED - Mecanismo Especial de Devolução)
fraud <- get_pix_fraud_stats(database = "202509")
```

## OData Filter and OrderBy

All functions support OData query parameters for filtering and ordering:

``` r
# Filter by state
get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Estado eq 'SÃO PAULO'"
)

# Multiple filters with 'and'
get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P' and PAG_REGIAO eq 'SUDESTE'"
)

# Order by value descending
get_pix_transaction_stats(
  database = "202509",
  orderby = "VALOR desc",
  top = 100
)
```

### Common Filter Examples

| Goal                       | Filter                                            |
|----------------------------|---------------------------------------------------|
| Filter by state            | `"Estado eq 'SÃO PAULO'"`                         |
| Filter by region           | `"Sigla_Regiao eq 'NE'"`                          |
| Filter by transaction type | `"NATUREZA eq 'P2P'"`                             |
| Filter by key type         | `"TipoChave eq 'CPF'"`                            |
| Numeric comparison         | `"VALOR gt 10000"`                                |
| Multiple conditions        | `"NATUREZA eq 'P2P' and PAG_REGIAO eq 'SUDESTE'"` |

See the [Working with OData
Queries](https://monitoramento.pe.gov.br/pixr/articles/odata-queries.md)
article for complete documentation.

## Working with the Data

All functions return tibbles that integrate seamlessly with the
tidyverse:

``` r
library(dplyr)
library(ggplot2)

# Analyze transactions by region
get_pix_transactions_by_region(database = "202512") |>
  mutate(
    total_value_billions = (vl_pagador_pf + vl_pagador_pj) / 1e9
  ) |>
  ggplot(aes(x = reorder(Regiao, total_value_billions), y = total_value_billions)) +
  geom_col(fill = "#008060") +
  coord_flip() +
  labs(
    title = "PIX Transaction Volume by Region",
    x = "Region",
    y = "Transaction Value (R$ Billions)"
  ) +
  theme_minimal()
```

## Configuration

### Timeout

The default timeout is 120 seconds. Change it for slow connections:

``` r
# Set timeout to 3 minutes
pix_timeout(180)

# Check current timeout
pix_timeout()

# Or use options
options(pixr.timeout = 180)
```

### Verbose Output

By default, all functions print progress messages. You can disable this:

``` r
# Suppress messages
data <- get_pix_keys(date = "2025-12-01", verbose = FALSE)
```

## Debugging

Use
[`pix_url()`](https://monitoramento.pe.gov.br/pixr/reference/pix_url.md)
to see the URL that would be called:

``` r
# See the URL for a query
pix_url(
  "TransacoesPixPorMunicipio",
  params = list(DataBase = "202512"),
  filter = "Estado eq 'MARANHÃO'",
  orderby = "Municipio desc",
  top = 10
)
```

## Next Steps

- Read the [Understanding PIX
  Data](https://monitoramento.pe.gov.br/pixr/articles/understanding-pix-data.md)
  article for detailed information about the data structure
- Check [Working with OData
  Queries](https://monitoramento.pe.gov.br/pixr/articles/odata-queries.md)
  for advanced filtering and querying
- See [Data Analysis
  Examples](https://monitoramento.pe.gov.br/pixr/articles/analysis-examples.md)
  for practical use cases

## References

- [BCB PIX Open Data
  Portal](https://dadosabertos.bcb.gov.br/dataset/pix)
- [API Swagger
  Documentation](https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/swagger-ui3#/)
- [PIX Official Page](https://www.bcb.gov.br/estabilidadefinanceira/pix)
