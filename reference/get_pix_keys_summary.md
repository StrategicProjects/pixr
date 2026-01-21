# Get PIX Keys Summary by Institution

Retrieves PIX keys data and returns a summary showing total keys by
institution, sorted by total keys.

## Usage

``` r
get_pix_keys_summary(date, n_top = 20, verbose = TRUE)
```

## Arguments

- date:

  Character string in "YYYY-MM-DD" format specifying the reference date.
  This parameter is **required**. The API returns data for the last day
  of the specified month.

- n_top:

  Integer; number of top institutions to return. Default is 20.

- verbose:

  Logical; if TRUE (default), prints progress messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with summary data by institution.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get top 20 institutions by total keys
get_pix_keys_summary(date = "2025-12-01")

# Get top 10 institutions
get_pix_keys_summary(date = "2025-12-01", n_top = 10)
} # }
```
