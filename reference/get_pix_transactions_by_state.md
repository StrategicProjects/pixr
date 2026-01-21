# Get PIX Transactions by State

A convenience wrapper around
[`get_pix_transactions_by_municipality()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_municipality.md)
that aggregates data at the state level.

## Usage

``` r
get_pix_transactions_by_state(database, verbose = TRUE)
```

## Arguments

- database:

  Character string in "YYYYMM" format specifying which month's data to
  retrieve. This parameter is **required**.

- verbose:

  Logical; if TRUE (default), prints progress messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with PIX transaction data aggregated by state.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get state-level aggregates for December 2025
states <- get_pix_transactions_by_state(database = "202512")
} # }
```
