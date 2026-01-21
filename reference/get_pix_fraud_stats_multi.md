# Get PIX Fraud Statistics for Multiple Months

Retrieves fraud statistics for multiple months and combines them into a
single tibble.

## Usage

``` r
get_pix_fraud_stats_multi(databases, ...)
```

## Arguments

- databases:

  Character vector of year-months in "YYYYMM" format.

- ...:

  Additional arguments passed to
  [`get_pix_fraud_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_fraud_stats.md).

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with combined fraud statistics.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get fraud data for Q3 2025
q3_fraud <- get_pix_fraud_stats_multi(
  databases = c("202507", "202508", "202509")
)
} # }
```
