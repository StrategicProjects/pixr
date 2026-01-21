# Get PIX Transactions by Municipality

Retrieves PIX transaction statistics aggregated by municipality, showing
the number and value of transactions from the perspective of both payers
and receivers.

## Usage

``` r
get_pix_transactions_by_municipality(
  database,
  filter = NULL,
  columns = NULL,
  top = NULL,
  skip = NULL,
  orderby = NULL,
  verbose = TRUE
)
```

## Arguments

- database:

  Character string in "YYYYMM" format specifying which month's data to
  retrieve. This parameter is **required**.

- filter:

  OData filter expression as a character string. Examples:

  - `"Estado eq 'SÃO PAULO'"` - Filter by state name

  - `"Sigla_Regiao eq 'SE'"` - Filter by region

  - `"Municipio eq 'RECIFE'"` - Filter by municipality name

- columns:

  Character vector of columns to return. If NULL, returns all columns.
  See "Available Columns" section.

- top:

  Integer; maximum number of records to return.

- skip:

  Integer; number of records to skip (for pagination).

- orderby:

  Character string specifying the column to sort by. Use `"Column"` for
  ascending or `"Column desc"` for descending order.

- verbose:

  Logical; if TRUE (default), prints progress messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with PIX transaction data by municipality.

## Details

The BCB PIX API requires a `database` parameter (YYYYMM format)
specifying which month's data to retrieve. The data is broken down by
municipality, person type (PF/PJ), and transaction direction
(payer/receiver).

## Available Columns

- AnoMes:

  Reference year-month in YYYYMM format

- Municipio_Ibge:

  IBGE municipality code

- Municipio:

  Municipality name

- Estado_Ibge:

  IBGE state code

- Estado:

  State name

- Sigla_Regiao:

  Region abbreviation (NE, SE, S, CO, N)

- Regiao:

  Region name (NORDESTE, SUDESTE, SUL, CENTRO-OESTE, NORTE)

- VL_PagadorPF:

  Total value paid by individuals (BRL)

- QT_PagadorPF:

  Number of transactions where individuals were payers

- VL_PagadorPJ:

  Total value paid by legal entities (BRL)

- QT_PagadorPJ:

  Number of transactions where legal entities were payers

- VL_RecebedorPF:

  Total value received by individuals (BRL)

- QT_RecebedorPF:

  Number of transactions where individuals were receivers

- VL_RecebedorPJ:

  Total value received by legal entities (BRL)

- QT_RecebedorPJ:

  Number of transactions where legal entities were receivers

- QT_PES_PagadorPF:

  Number of distinct individual payers

- QT_PES_PagadorPJ:

  Number of distinct legal entity payers

- QT_PES_RecebedorPF:

  Number of distinct individual receivers

- QT_PES_RecebedorPJ:

  Number of distinct legal entity receivers

## Examples

``` r
if (FALSE) { # \dontrun{
# Get municipality transaction data for December 2025
muni <- get_pix_transactions_by_municipality(database = "202512")

# Filter by state
maranhao <- get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Estado eq 'MARANHÃO'",
  orderby = "Municipio desc",
  top = 10
)

# Filter by region
nordeste <- get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Sigla_Regiao eq 'NE'"
)

# Order by value
top_value <- get_pix_transactions_by_municipality(
  database = "202512",
  orderby = "VL_PagadorPF desc",
  top = 100
)
} # }
```
