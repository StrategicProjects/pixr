# Get PIX Fraud Statistics (MED)

Retrieves fraud statistics for PIX transactions reported through the
Special Return Mechanism (MED - Mecanismo Especial de Devolução).

## Usage

``` r
get_pix_fraud_stats(
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

  OData filter expression as a character string.

- columns:

  Character vector of columns to return. If NULL, returns all columns.

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
with PIX fraud statistics.

## Details

The MED (Mecanismo Especial de Devolução) is a mechanism created by the
Brazilian Central Bank to facilitate the return of funds in cases of
fraud or operational errors in PIX transactions.

This endpoint provides statistics on:

- Number of fraud reports (notificações de infração)

- Number of return requests (pedidos de devolução)

- Values involved in fraud cases

## Examples

``` r
if (FALSE) { # \dontrun{
# Get fraud statistics for September 2025
fraud <- get_pix_fraud_stats(database = "202509")

# Get top 100 records
fraud <- get_pix_fraud_stats(database = "202509", top = 100)
} # }
```
