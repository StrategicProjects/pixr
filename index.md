# pixr

> Access Brazilian Central Bank PIX Open Data API from R

## Overview

**pixr** provides a tidyverse-style interface to the Brazilian Central
Bank (BCB) PIX Open Data API. Retrieve statistics on PIX keys,
transactions by municipality, transaction breakdowns, and fraud
statistics.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("StrategicProjects/pixr")
```

## Configuration

### Timeout

The default timeout for API requests is **120 seconds**. You can change
it:

``` r
# Using the helper function
pix_timeout(180)  # Set to 3 minutes

# Or via options
options(pixr.timeout = 180)
```

## API Endpoints

Each endpoint has a different parameter name and format:

| Endpoint                    | Parameter  | Format       | R Function                                                                                                                         |
|-----------------------------|------------|--------------|------------------------------------------------------------------------------------------------------------------------------------|
| `ChavesPix`                 | `Data`     | `YYYY-MM-DD` | [`get_pix_keys()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_keys.md)                                                 |
| `TransacoesPixPorMunicipio` | `DataBase` | `YYYYMM`     | [`get_pix_transactions_by_municipality()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_municipality.md) |
| `EstatisticasTransacoesPix` | `Database` | `YYYYMM`     | [`get_pix_transaction_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transaction_stats.md)                       |
| `EstatisticasFraudesPix`    | `Database` | `YYYYMM`     | [`get_pix_fraud_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_fraud_stats.md)                                   |

## Quick Start

``` r
library(pixr)

# PIX Keys Stock (uses date in YYYY-MM-DD format)
keys <- get_pix_keys(date = "2025-12-01")

# Transaction Statistics (uses database in YYYYMM format)
stats <- get_pix_transaction_stats(database = "202509")

# Transactions by Municipality
muni <- get_pix_transactions_by_municipality(database = "202512")

# Fraud Statistics (MED)
fraud <- get_pix_fraud_stats(database = "202509")
```

## OData Filter and OrderBy

All functions support OData `filter` and `orderby` parameters:

``` r
# Filter by state and order by municipality name (descending)
maranhao <- get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Estado eq 'MARANHÃO'",
  orderby = "Municipio desc",
  top = 10
)

# Filter by transaction nature
p2p <- get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P'"
)

# Multiple filters using 'and'
filtered <- get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P' and PAG_REGIAO eq 'NORDESTE'"
)

# Filter PIX keys by type
cpf_keys <- get_pix_keys(
  date = "2025-12-01",
  filter = "TipoChave eq 'CPF'",
  orderby = "qtdChaves desc",
  top = 100
)
```

### OData Filter Syntax

| Operator | Description      | Example                                           |
|----------|------------------|---------------------------------------------------|
| `eq`     | Equal            | `"Estado eq 'SÃO PAULO'"`                         |
| `ne`     | Not equal        | `"NATUREZA ne 'P2P'"`                             |
| `gt`     | Greater than     | `"VALOR gt 1000"`                                 |
| `ge`     | Greater or equal | `"QUANTIDADE ge 100"`                             |
| `lt`     | Less than        | `"VALOR lt 5000"`                                 |
| `le`     | Less or equal    | `"QUANTIDADE le 50"`                              |
| `and`    | Logical AND      | `"NATUREZA eq 'P2P' and PAG_REGIAO eq 'SUDESTE'"` |
| `or`     | Logical OR       | `"Estado eq 'SP' or Estado eq 'RJ'"`              |

## Available Functions

### Data Retrieval Functions

| Function                                                                                                                           | Description                      |
|------------------------------------------------------------------------------------------------------------------------------------|----------------------------------|
| [`get_pix_keys()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_keys.md)                                                 | PIX keys stock by participant    |
| [`get_pix_keys_summary()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_keys_summary.md)                                 | Top institutions by key count    |
| [`get_pix_keys_by_type()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_keys_by_type.md)                                 | Keys aggregated by type          |
| [`get_pix_transaction_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transaction_stats.md)                       | Detailed transaction statistics  |
| [`get_pix_summary()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_summary.md)                                           | Aggregated summaries by grouping |
| [`get_pix_transaction_stats_multi()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transaction_stats_multi.md)           | Stats for multiple months        |
| [`get_pix_transactions_by_municipality()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_municipality.md) | Transactions by municipality     |
| [`get_pix_transactions_by_state()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_state.md)               | Aggregated by state              |
| [`get_pix_transactions_by_region()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_region.md)             | Aggregated by region             |
| [`get_pix_fraud_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_fraud_stats.md)                                   | Fraud statistics (MED)           |

### Utility Functions

| Function                                                                             | Description                   |
|--------------------------------------------------------------------------------------|-------------------------------|
| [`pix_endpoints()`](https://monitoramento.pe.gov.br/pixr/reference/pix_endpoints.md) | List available API endpoints  |
| [`pix_columns()`](https://monitoramento.pe.gov.br/pixr/reference/pix_columns.md)     | Column info for each endpoint |
| [`pix_timeout()`](https://monitoramento.pe.gov.br/pixr/reference/pix_timeout.md)     | Get or set request timeout    |
| [`pix_url()`](https://monitoramento.pe.gov.br/pixr/reference/pix_url.md)             | Build API URL for debugging   |
| [`pix_query()`](https://monitoramento.pe.gov.br/pixr/reference/pix_query.md)         | Custom OData queries          |

## Examples

### PIX Keys

``` r
library(pixr)
library(dplyr)

# Get keys stock for December 2025
keys <- get_pix_keys(date = "2025-12-01")

# Top 20 institutions
get_pix_keys_summary(date = "2025-12-01", n_top = 20)

# Aggregate by key type
keys |>
  group_by(TipoChave, NaturezaUsuario) |>
  summarise(total = sum(qtdChaves), .groups = "drop")
```

### Transaction Statistics

``` r
# Get statistics for September 2025
stats <- get_pix_transaction_stats(database = "202509")

# Summary by transaction nature (P2P, P2B, etc.)
get_pix_summary(database = "202509", group_by = "NATUREZA")

# Multiple months
q3_data <- get_pix_transaction_stats_multi(
  databases = c("202507", "202508", "202509")
)
```

### Transactions by Municipality

``` r
# Get all municipalities
muni <- get_pix_transactions_by_municipality(database = "202512")

# Filter by state
sp <- muni |> filter(Estado == "SÃO PAULO")

# Aggregate by state
get_pix_transactions_by_state(database = "202512")

# Aggregate by region
get_pix_transactions_by_region(database = "202512")
```

### Debugging

``` r
# See the URL that would be called
pix_url("ChavesPix", params = list(Data = "2025-12-01"), top = 10)
pix_url("EstatisticasTransacoesPix", params = list(Database = "202509"))
```

## References

- [BCB PIX Open Data
  Portal](https://dadosabertos.bcb.gov.br/dataset/pix)
- [API Swagger
  Documentation](https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/swagger-ui3#/)
- [PIX Official Page](https://www.bcb.gov.br/estabilidadefinanceira/pix)

## License

MIT © pixr authors
