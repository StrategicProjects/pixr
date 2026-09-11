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
if (FALSE) # It usually takes much longer than 5 seconds.
# Summary by transaction nature
get_pix_summary(database = "202509", group_by = "NATUREZA")

# Summary by payer region
get_pix_summary(database = "202509", group_by = "PAG_REGIAO")
#> 
#> ── Fetching PIX Transaction Summary ──
#> 
#> ── Fetching PIX Transaction Statistics ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/EstatisticasTransacoesPix(Database=@Database)?$format=json&@Database='202509'
#> ✔ Retrieved 177045 records
#> ✔ Aggregated into 6 groups
#> # A tibble: 6 × 5
#>   PAG_REGIAO    total_value total_count avg_value n_records
#>   <chr>               <dbl>       <dbl>     <dbl>     <int>
#> 1 SUDESTE           1.93e13 34414174888      561.     32589
#> 2 SUL               5.51e12  9854864417      559.     29354
#> 3 NORDESTE          4.98e12 21528412065      231.     31483
#> 4 CENTRO-OESTE      3.05e12  6841305710      446.     30014
#> 5 NORTE             1.81e12  7919264071      229.     29805
#> 6 Nao informado     6.25e10    70643276      884.     23800

# Summary by nature and initiation method
get_pix_summary(database = "202509", group_by = c("NATUREZA", "FORMAINICIACAO"))
#> 
#> ── Fetching PIX Transaction Summary ──
#> 
#> ── Fetching PIX Transaction Statistics ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/EstatisticasTransacoesPix(Database=@Database)?$format=json&@Database='202509'
#> ✔ Retrieved 177045 records
#> ✔ Aggregated into 68 groups
#> # A tibble: 68 × 6
#>    NATUREZA FORMAINICIACAO total_value total_count avg_value n_records
#>    <chr>    <chr>                <dbl>       <dbl>     <dbl>     <int>
#>  1 B2B      MANU               1.06e13  1059403241   10046.        516
#>  2 P2P      DICT               6.76e12 21426337272     315.      20843
#>  3 B2B      DICT               5.70e12   799059228    7132.        432
#>  4 B2P      DICT               2.95e12  5935229785     497.       3003
#>  5 P2B      QRDN               1.98e12 30571594094      64.6      6590
#>  6 P2P      MANU               1.77e12  6315193178     280.      19306
#>  7 P2B      DICT               1.41e12  2298838270     614.       3095
#>  8 B2P      MANU               1.06e12  1004752672    1057.       3169
#>  9 B2B      QRDN               7.19e11  1088029514     661.        824
#> 10 P2B      QRES               4.76e11  3274304287     146.       4361
#> # ℹ 58 more rows
 # \dontrun{}
```
