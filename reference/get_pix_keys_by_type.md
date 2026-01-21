# Get PIX Keys by Key Type

Retrieves PIX keys data and returns a summary by key type.

## Usage

``` r
get_pix_keys_by_type(date, verbose = TRUE)
```

## Arguments

- date:

  Character string in "YYYY-MM-DD" format specifying the reference date.
  This parameter is **required**. The API returns data for the last day
  of the specified month.

- verbose:

  Logical; if TRUE (default), prints progress messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with summary data by key type.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get summary by key type
get_pix_keys_by_type(date = "2025-12-01")
} # }
```
