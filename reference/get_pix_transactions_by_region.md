# Get PIX Transactions by Region

A convenience wrapper that aggregates municipality data at the region
level.

## Usage

``` r
get_pix_transactions_by_region(database, verbose = TRUE)
```

## Arguments

- database:

  Character string in "YYYYMM" format specifying which month's data to
  retrieve. This parameter is **required**.

- verbose:

  Logical; if TRUE (default), prints progress messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with PIX transaction data aggregated by region.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get region-level aggregates
regions <- get_pix_transactions_by_region(database = "202512")
} # }
```
