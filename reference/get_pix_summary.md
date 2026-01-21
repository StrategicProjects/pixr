# Get PIX Transaction Summary

Retrieves transaction statistics and aggregates them by specified
grouping variables. This is a convenience function that fetches data and
performs common aggregations.

## Usage

``` r
get_pix_summary(database, group_by = "NATUREZA", verbose = TRUE)
```

## Arguments

- database:

  Character string in "YYYYMM" format specifying which month's data to
  retrieve. This parameter is **required**.

- group_by:

  Character vector of columns to group by. Common choices: "NATUREZA",
  "PAG_REGIAO", "REC_REGIAO", "FORMAINICIACAO".

- verbose:

  Logical; if TRUE (default), prints progress messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with aggregated transaction statistics.

## Examples

``` r
if (FALSE) { # \dontrun{
# Summary by transaction nature
get_pix_summary(database = "202509", group_by = "NATUREZA")

# Summary by payer region
get_pix_summary(database = "202509", group_by = "PAG_REGIAO")

# Summary by nature and initiation method
get_pix_summary(database = "202509", group_by = c("NATUREZA", "FORMAINICIACAO"))
} # }
```
