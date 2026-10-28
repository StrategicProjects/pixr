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
# It usually takes much longer than 5 seconds.
# Summary by transaction nature
get_pix_summary(database = "202509", group_by = "NATUREZA")
#> 
#> ── Fetching PIX Transaction Summary ──
#> 
#> ── Fetching PIX Transaction Statistics ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/EstatisticasTransacoesPix(Database=@Database)?$format=json&@Database='202509'
#> ✔ Retrieved 190395 records
#> ✔ Aggregated into 10 groups
#> # A tibble: 10 × 5
#>    NATUREZA       total_value total_count avg_value n_records
#>    <chr>                <dbl>       <dbl>     <dbl>     <int>
#>  1 B2B                1.89e13  3536170499    5356.       3651
#>  2 P2P                9.58e12 35798278870     268.     120272
#>  3 P2B                4.44e12 39924692369     111.      29022
#>  4 B2P                4.44e12  8162714816     544.      16805
#>  5 B2G                2.24e11   104694862    2140.       1706
#>  6 G2B                1.27e11     4418238   28800.       1559
#>  7 P2G                8.57e10   220916213     388.      10240
#>  8 G2G                7.45e10      948358   78550.        718
#>  9 G2P                5.23e10    36492165    1432.       6412
#> 10 Nao disponivel     6.62e 8     9062431      73.1        10

# Summary by payer region
get_pix_summary(database = "202509", group_by = "PAG_REGIAO")
#> 
#> ── Fetching PIX Transaction Summary ──
#> 
#> ── Fetching PIX Transaction Statistics ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/EstatisticasTransacoesPix(Database=@Database)?$format=json&@Database='202509'
#> ✔ Retrieved 190395 records
#> ✔ Aggregated into 6 groups
#> # A tibble: 6 × 5
#>   PAG_REGIAO    total_value total_count avg_value n_records
#>   <chr>               <dbl>       <dbl>     <dbl>     <int>
#> 1 SUDESTE           2.11e13 37472905087      564.     35029
#> 2 SUL               6.02e12 10751504676      560.     31570
#> 3 NORDESTE          5.43e12 23420061491      232.     33846
#> 4 CENTRO-OESTE      3.33e12  7441928894      448.     32292
#> 5 NORTE             1.98e12  8634627361      230.     32031
#> 6 Nao informado     7.53e10    77361312      974.     25627

# Summary by nature and initiation method
get_pix_summary(database = "202509", group_by = c("NATUREZA", "FORMAINICIACAO"))
#> 
#> ── Fetching PIX Transaction Summary ──
#> 
#> ── Fetching PIX Transaction Statistics ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/EstatisticasTransacoesPix(Database=@Database)?$format=json&@Database='202509'
#> ✔ Retrieved 190395 records
#> ✔ Aggregated into 68 groups
#> # A tibble: 68 × 6
#>    NATUREZA FORMAINICIACAO total_value total_count avg_value n_records
#>    <chr>    <chr>                <dbl>       <dbl>     <dbl>     <int>
#>  1 B2B      MANU               1.17e13  1157575023   10086.        569
#>  2 P2P      DICT               7.36e12 23329316407     315.      22267
#>  3 B2B      DICT               6.25e12   874120906    7155.        468
#>  4 B2P      DICT               3.22e12  6463975559     498.       3236
#>  5 P2B      QRDN               2.16e12 33369614818      64.6      7035
#>  6 P2P      MANU               1.90e12  6768244899     281.      20687
#>  7 P2B      DICT               1.54e12  2504313411     615.       3319
#>  8 B2P      MANU               1.15e12  1088818947    1058.       3482
#>  9 B2B      QRDN               7.89e11  1194991838     660.        889
#> 10 P2B      QRES               5.22e11  3565764967     146.       4691
#> # ℹ 58 more rows
```
