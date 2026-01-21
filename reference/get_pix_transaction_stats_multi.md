# Get PIX Transaction Statistics for Multiple Months

Retrieves transaction statistics for multiple months and combines them
into a single tibble.

## Usage

``` r
get_pix_transaction_stats_multi(databases, ...)
```

## Arguments

- databases:

  Character vector of year-months in "YYYYMM" format.

- ...:

  Additional arguments passed to
  [`get_pix_transaction_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transaction_stats.md).

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with combined transaction statistics.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get data for Q3 2025
q3_data <- get_pix_transaction_stats_multi(
  databases = c("202507", "202508", "202509")
)
} # }
```
