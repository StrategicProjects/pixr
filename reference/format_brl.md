# Format Currency Value

Formats a numeric value as Brazilian Real (BRL) currency.

## Usage

``` r
format_brl(x, prefix = TRUE, decimal_mark = ",", big_mark = ".")
```

## Arguments

- x:

  Numeric vector.

- prefix:

  Logical; if TRUE (default), includes "R\$" prefix.

- decimal_mark:

  Character to use as decimal separator.

- big_mark:

  Character to use as thousands separator.

## Value

A character vector with formatted currency values.

## Examples

``` r
format_brl(1234567.89)
#> [1] "R$ 1.234.567,89"
format_brl(c(1000, 2000, 3000))
#> [1] "R$ 1.000,00" "R$ 2.000,00" "R$ 3.000,00"
```
