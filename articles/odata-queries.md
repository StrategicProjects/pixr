# Working with OData Queries

## Introduction to OData

The BCB PIX Open Data API uses the OData (Open Data Protocol) standard
for data access. OData provides a standardized way to query and
manipulate data using RESTful APIs.

The **pixr** package provides full support for OData query parameters
including `$filter`, `$orderby`, `$select`, `$top`, and `$skip`.

## API Endpoints and Parameters

Each endpoint requires a specific date/database parameter:

| Endpoint                  | Parameter  | Format     | R Function                                                  |
|---------------------------|------------|------------|-------------------------------------------------------------|
| ChavesPix                 | `Data`     | YYYY-MM-DD | `get_pix_keys(date = "2025-12-01")`                         |
| TransacoesPixPorMunicipio | `DataBase` | YYYYMM     | `get_pix_transactions_by_municipality(database = "202512")` |
| EstatisticasTransacoesPix | `Database` | YYYYMM     | `get_pix_transaction_stats(database = "202509")`            |
| EstatisticasFraudesPix    | `Database` | YYYYMM     | `get_pix_fraud_stats(database = "202509")`                  |

## Filtering with \$filter

All main functions accept a `filter` parameter that uses OData filter
syntax.

### Basic Filter Syntax

``` r
library(pixr)

# Filter transactions by state
get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Estado eq 'MARANHÃO'"
)

# Filter by region
get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Sigla_Regiao eq 'NE'"
)

# Filter transaction stats by nature
get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P'"
)

# Filter PIX keys by key type
get_pix_keys(
  date = "2025-12-01",
  filter = "TipoChave eq 'CPF'"
)
```

### Comparison Operators

| Operator | Meaning          | Example                   |
|----------|------------------|---------------------------|
| `eq`     | Equal            | `"Estado eq 'SÃO PAULO'"` |
| `ne`     | Not equal        | `"NATUREZA ne 'P2P'"`     |
| `gt`     | Greater than     | `"VALOR gt 1000"`         |
| `ge`     | Greater or equal | `"QUANTIDADE ge 100"`     |
| `lt`     | Less than        | `"VALOR lt 5000"`         |
| `le`     | Less or equal    | `"qtdChaves le 1000"`     |

``` r
# Greater than
get_pix_transaction_stats(
  database = "202509",
  filter = "VALOR gt 10000"
)

# Less than or equal
get_pix_keys(
  date = "2025-12-01",
  filter = "qtdChaves le 1000"
)
```

### Logical Operators

Combine multiple conditions with `and` and `or`:

| Operator | Example                                           |
|----------|---------------------------------------------------|
| `and`    | `"NATUREZA eq 'P2P' and PAG_REGIAO eq 'SUDESTE'"` |
| `or`     | `"Estado eq 'SP' or Estado eq 'RJ'"`              |

``` r
# AND - both conditions must be true
get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P' and PAG_REGIAO eq 'SUDESTE'"
)

# OR - either condition can be true
get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Estado eq 'SÃO PAULO' or Estado eq 'RIO DE JANEIRO'"
)

# Complex filter with multiple conditions
get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P' and PAG_REGIAO eq 'NORDESTE' and VALOR gt 1000"
)
```

### String Functions

The API supports string functions for text matching:

| Function                   | Description     | Example                      |
|----------------------------|-----------------|------------------------------|
| `contains(field, value)`   | Substring match | `"contains(Nome, 'BANCO')"`  |
| `startswith(field, value)` | Starts with     | `"startswith(Nome, 'COOP')"` |
| `endswith(field, value)`   | Ends with       | `"endswith(Nome, 'S.A.')"`   |

``` r
# Find institutions containing "SICREDI"
get_pix_keys(
  date = "2025-12-01",
  filter = "contains(Nome, 'SICREDI')"
)

# Find cooperatives (starting with COOP)
get_pix_keys(
  date = "2025-12-01",
  filter = "startswith(Nome, 'COOP')"
)
```

## Ordering with \$orderby

Sort results by any column using the `orderby` parameter.

### Basic Ordering

``` r
# Ascending order (default)
get_pix_keys(
  date = "2025-12-01",
  orderby = "qtdChaves"
)

# Descending order (add "desc")
get_pix_keys(
  date = "2025-12-01",
  orderby = "qtdChaves desc"
)

# Order municipalities alphabetically
get_pix_transactions_by_municipality(
  database = "202512",
  orderby = "Municipio"
)

# Order by value descending
get_pix_transaction_stats(
  database = "202509",
  orderby = "VALOR desc"
)
```

### Combining Filter and OrderBy

``` r
# Filter by state and order by municipality name (descending)
get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Estado eq 'MARANHÃO'",
  orderby = "Municipio desc",
  top = 10
)

# Filter P2P transactions and order by value
get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P'",
  orderby = "VALOR desc",
  top = 100
)

# Filter by key type and order by quantity
get_pix_keys(
  date = "2025-12-01",
  filter = "TipoChave eq 'CPF' and NaturezaUsuario eq 'PF'",
  orderby = "qtdChaves desc",
  top = 50
)
```

## Selecting Columns with \$select

Retrieve only the columns you need using the `columns` parameter:

``` r
# Select specific columns for PIX keys
get_pix_keys(
  date = "2025-12-01",
  columns = c("Nome", "ISPB", "TipoChave", "qtdChaves"),
  top = 100
)

# Select specific columns for transactions
get_pix_transactions_by_municipality(
  database = "202512",
  columns = c("Estado", "Municipio", "VL_PagadorPF", "QT_PagadorPF"),
  top = 100
)
```

## Pagination with \$top and \$skip

Control the number of results returned:

``` r
# Get first 10 records
get_pix_keys(date = "2025-12-01", top = 10)

# Skip first 100 records, get next 50
get_pix_keys(date = "2025-12-01", top = 50, skip = 100)
```

### Iterating Through All Data

For large datasets, use pagination to download in batches:

``` r
# Download all data in chunks
all_data <- list()
skip <- 0
batch_size <- 1000

repeat {
  batch <- get_pix_keys(
    date = "2025-12-01",
    top = batch_size,
    skip = skip,
    verbose = FALSE
  )
 
  if (nrow(batch) == 0) break
 
  all_data <- c(all_data, list(batch))
  skip <- skip + batch_size
 
  if (nrow(batch) < batch_size) break
}

# Combine all batches
final_data <- dplyr::bind_rows(all_data)
```

## Custom Queries with pix_query()

For advanced use cases, use
[`pix_query()`](https://monitoramento.pe.gov.br/pixr/reference/pix_query.md)
with raw OData parameters:

``` r
# Custom query with all parameters
pix_query(
  endpoint = "TransacoesPixPorMunicipio",
  params = list(DataBase = "202512"),
  filter = "Sigla_Regiao eq 'SE'",
  select = c("Estado", "Municipio", "VL_PagadorPF"),
  orderby = "VL_PagadorPF desc",
  top = 50
)

# Custom query for transaction stats
pix_query(
  endpoint = "EstatisticasTransacoesPix",
  params = list(Database = "202509"),
  filter = "NATUREZA eq 'P2B' and FORMAINICIACAO eq 'QRDN'",
  orderby = "QUANTIDADE desc",
  top = 100
)
```

## Building and Debugging URLs

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
# Returns:
# https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/
#   TransacoesPixPorMunicipio(DataBase=@DataBase)?$format=json&@DataBase='202512'
#   &$filter=Estado eq 'MARANHÃO'&$orderby=Municipio desc&$top=10
```

## Practical Examples

### Top 10 States by Transaction Volume

``` r
library(dplyr)

# Get all municipalities and aggregate by state
get_pix_transactions_by_municipality(database = "202512") |>
  group_by(Estado) |>
  summarise(
    total_value = sum(VL_PagadorPF + VL_PagadorPJ),
    total_count = sum(QT_PagadorPF + QT_PagadorPJ),
    n_municipalities = n()
  ) |>
  arrange(desc(total_value)) |>
  head(10)
```

### P2P vs P2B Transactions by Region

``` r
# Get P2P transactions by region
p2p <- get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P'"
) |>
  group_by(PAG_REGIAO) |>
  summarise(p2p_value = sum(VALOR))

# Get P2B transactions by region
p2b <- get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2B'"
) |>
  group_by(PAG_REGIAO) |>
  summarise(p2b_value = sum(VALOR))

# Join and compare
left_join(p2p, p2b, by = "PAG_REGIAO")
```

### Market Share by Key Type

``` r
# Get keys by type
get_pix_keys(date = "2025-12-01") |>
  group_by(TipoChave) |>
  summarise(total_keys = sum(qtdChaves)) |>
  mutate(share = total_keys / sum(total_keys) * 100) |>
  arrange(desc(share))
```

## Performance Tips

1.  **Use filters server-side**: Let the API filter instead of
    downloading all data

``` r
# Good: Filter on the server
get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Estado eq 'SÃO PAULO'"
)

# Avoid: Downloading all data then filtering in R
get_pix_transactions_by_municipality(database = "202512") |>
  dplyr::filter(Estado == "SÃO PAULO")
```

2.  **Select only needed columns**: Reduces response size

``` r
# Good: Request only what you need
get_pix_keys(
  date = "2025-12-01",
  columns = c("Nome", "qtdChaves")
)
```

3.  **Use `top` during development**: Limit results when exploring

``` r
# Good: Explore with limited data
get_pix_keys(date = "2025-12-01", top = 10)
```

4.  **Disable verbose mode in loops**: Reduces output clutter

``` r
get_pix_keys(date = "2025-12-01", verbose = FALSE)
```

## Filter Reference by Endpoint

### ChavesPix (PIX Keys)

| Column          | Type    | Filter Example                                                                                                                       |
|-----------------|---------|--------------------------------------------------------------------------------------------------------------------------------------|
| Nome            | string  | `"Nome eq 'BANCO DO BRASIL S.A.'"`                                                                                                   |
| ISPB            | string  | `"ISPB eq '00000000'"`                                                                                                               |
| NaturezaUsuario | string  | `"NaturezaUsuario eq 'PF'"` or `"NaturezaUsuario eq 'PJ'"`                                                                           |
| TipoChave       | string  | `"TipoChave eq 'CPF'"`, `"TipoChave eq 'Celular'"`, `"TipoChave eq 'e-mail'"`, `"TipoChave eq 'Aleatória'"`, `"TipoChave eq 'CNPJ'"` |
| qtdChaves       | numeric | `"qtdChaves gt 1000"`                                                                                                                |

### TransacoesPixPorMunicipio (Transactions by Municipality)

| Column       | Type    | Filter Example                              |
|--------------|---------|---------------------------------------------|
| Estado       | string  | `"Estado eq 'SÃO PAULO'"`                   |
| Municipio    | string  | `"Municipio eq 'RECIFE'"`                   |
| Sigla_Regiao | string  | `"Sigla_Regiao eq 'NE'"` (NE, SE, S, CO, N) |
| Regiao       | string  | `"Regiao eq 'NORDESTE'"`                    |
| VL_PagadorPF | numeric | `"VL_PagadorPF gt 1000000"`                 |

### EstatisticasTransacoesPix (Transaction Statistics)

| Column         | Type    | Filter Example                                              |
|----------------|---------|-------------------------------------------------------------|
| PAG_PFPJ       | string  | `"PAG_PFPJ eq 'PF'"`                                        |
| REC_PFPJ       | string  | `"REC_PFPJ eq 'PJ'"`                                        |
| PAG_REGIAO     | string  | `"PAG_REGIAO eq 'SUDESTE'"`                                 |
| REC_REGIAO     | string  | `"REC_REGIAO eq 'NORDESTE'"`                                |
| NATUREZA       | string  | `"NATUREZA eq 'P2P'"` (P2P, P2B, B2P, B2B, P2G, G2P)        |
| FORMAINICIACAO | string  | `"FORMAINICIACAO eq 'DICT'"` (DICT, QRDN, QRES, MANU, INIC) |
| FINALIDADE     | string  | `"FINALIDADE eq 'Pix'"`                                     |
| VALOR          | numeric | `"VALOR gt 10000"`                                          |
| QUANTIDADE     | numeric | `"QUANTIDADE ge 100"`                                       |

## See Also

- [Getting
  Started](https://monitoramento.pe.gov.br/pixr/articles/pixr.md) -
  Package introduction
- [Understanding PIX
  Data](https://monitoramento.pe.gov.br/pixr/articles/understanding-pix-data.md) -
  Data structure details
- [Data Analysis
  Examples](https://monitoramento.pe.gov.br/pixr/articles/analysis-examples.md) -
  Practical use cases

## References

- [OData Protocol Documentation](https://www.odata.org/documentation/)
- [BCB API
  Swagger](https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/swagger-ui3#/)
- [BCB PIX Data Portal](https://dadosabertos.bcb.gov.br/dataset/pix)
