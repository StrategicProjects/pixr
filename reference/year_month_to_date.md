# Convert Year-Month String to Date

Converts a year-month string in "YYYYMM" format to a Date object (first
day of the month).

## Usage

``` r
year_month_to_date(year_month)
```

## Arguments

- year_month:

  Character vector of year-month strings in "YYYYMM" format.

## Value

A Date vector.

## Examples

``` r
year_month_to_date("202312")
#> [1] "2023-12-01"
year_month_to_date(c("202301", "202302", "202303"))
#> [1] "2023-01-01" "2023-02-01" "2023-03-01"
```
