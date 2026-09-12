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
#> ✔ Retrieved 66501 records
#> ✔ Aggregated into 10 groups
#> # A tibble: 10 × 5
#>    NATUREZA       total_value total_count avg_value n_records
#>    <chr>                <dbl>       <dbl>     <dbl>     <int>
#>  1 B2B                6.69e12  1221192401     5478.      1338
#>  2 P2P                3.68e12 13792624507      267.     41069
#>  3 B2P                1.68e12  2975764599      564.      5881
#>  4 P2B                1.64e12 14393306922      114.     10574
#>  5 B2G                8.17e10    35259782     2316.       654
#>  6 G2B                3.88e10     1670958    23206.       573
#>  7 P2G                3.07e10    79821732      385.      3754
#>  8 G2G                3.04e10      249657   121607.       274
#>  9 G2P                1.01e10     6367428     1580.      2380
#> 10 Nao disponivel     5.16e 8     3730614      138.         4

# Summary by payer region
get_pix_summary(database = "202509", group_by = "PAG_REGIAO")
#> 
#> ── Fetching PIX Transaction Summary ──
#> 
#> ── Fetching PIX Transaction Statistics ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/EstatisticasTransacoesPix(Database=@Database)?$format=json&@Database='202509'
#> ✔ Retrieved 66501 records
#> ✔ Aggregated into 6 groups
#> # A tibble: 6 × 5
#>   PAG_REGIAO    total_value total_count avg_value n_records
#>   <chr>               <dbl>       <dbl>     <dbl>     <int>
#> 1 SUDESTE           7.64e12 13833665231      552.     12178
#> 2 SUL               2.21e12  3984682444      555.     10898
#> 3 NORDESTE          2.05e12  8766064571      234.     11922
#> 4 CENTRO-OESTE      1.22e12  2731747254      447.     11216
#> 5 NORTE             7.32e11  3163683981      231.     11304
#> 6 Nao informado     2.02e10    30145119      670.      8983

# Summary by nature and initiation method
get_pix_summary(database = "202509", group_by = c("NATUREZA", "FORMAINICIACAO"))
#> 
#> ── Fetching PIX Transaction Summary ──
#> 
#> ── Fetching PIX Transaction Statistics ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/EstatisticasTransacoesPix(Database=@Database)?$format=json&@Database='202509'
#> ✔ Retrieved 66501 records
#> ✔ Aggregated into 62 groups
#> # A tibble: 62 × 6
#>    NATUREZA FORMAINICIACAO total_value total_count avg_value n_records
#>    <chr>    <chr>                <dbl>       <dbl>     <dbl>     <int>
#>  1 B2B      MANU               4.11e12   394529797   10418.        190
#>  2 P2P      DICT               2.79e12  8900522889     314.       7835
#>  3 B2B      DICT               2.23e12   313855500    7116.        180
#>  4 B2P      DICT               1.21e12  2373686080     511.       1180
#>  5 P2B      QRDN               7.79e11 11978936685      65.0      2754
#>  6 P2P      MANU               7.61e11  2731731535     279.       6979
#>  7 P2B      DICT               5.79e11   922126399     628.       1264
#>  8 B2P      MANU               4.42e11   398255318    1109.       1104
#>  9 B2B      QRDN               2.75e11   408288861     673.        370
#> 10 P2B      QRES               1.85e11  1306751249     142.       1775
#> # ℹ 52 more rows
```
