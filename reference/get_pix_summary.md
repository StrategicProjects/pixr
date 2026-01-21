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
#> ✔ Retrieved 53191 records
#> ✔ Aggregated into 6 groups
#> # A tibble: 6 × 5
#>   PAG_REGIAO    total_value total_count avg_value n_records
#>   <chr>               <dbl>       <dbl>     <dbl>     <int>
#> 1 SUDESTE           6.13e12 11136043385      551.      9752
#> 2 SUL               1.78e12  3160524159      563.      8720
#> 3 NORDESTE          1.66e12  7095875693      234.      9534
#> 4 CENTRO-OESTE      9.92e11  2184740818      454.      8980
#> 5 NORTE             5.93e11  2546883325      233.      9033
#> 6 Nao informado     1.50e10    21745840      692.      7172

# Summary by nature and initiation method
get_pix_summary(database = "202509", group_by = c("NATUREZA", "FORMAINICIACAO"))
#> 
#> ── Fetching PIX Transaction Summary ──
#> 
#> ── Fetching PIX Transaction Statistics ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/EstatisticasTransacoesPix(Database=@Database)?$format=json&@Database='202509'
#> ✔ Retrieved 53191 records
#> ✔ Aggregated into 60 groups
#> # A tibble: 60 × 6
#>    NATUREZA FORMAINICIACAO total_value total_count avg_value n_records
#>    <chr>    <chr>                <dbl>       <dbl>     <dbl>     <int>
#>  1 B2B      MANU               3.29e12   309752158   10608.        150
#>  2 P2P      DICT               2.27e12  7244649589     313.       6378
#>  3 B2B      DICT               1.80e12   253233949    7096.        144
#>  4 B2P      DICT               9.91e11  1899866271     522.        942
#>  5 P2B      QRDN               6.21e11  9540673851      65.1      2233
#>  6 P2P      MANU               6.15e11  2219072261     277.       5599
#>  7 P2B      DICT               4.71e11   746199559     632.       1032
#>  8 B2P      MANU               3.62e11   323488247    1118.        883
#>  9 B2B      QRDN               2.14e11   318512083     671.        293
#> 10 P2B      QRES               1.47e11  1048823015     140.       1444
#> # ℹ 50 more rows
 # \dontrun{}
```
