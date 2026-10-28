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
# It usually takes much longer than 5 seconds.
# Get top 20 institutions by total keys
get_pix_keys_summary(date = "2025-12-01")
#> 
#> ── Fetching PIX Keys Summary ──
#> 
#> ── Fetching PIX Keys Stock Data ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/ChavesPix(Data=@Data)?$format=json&@Data='2025-12-01'
#> ✔ Retrieved 61557 records
#> ✔ Returning top 20 institutions
#> # A tibble: 20 × 6
#>    Nome                             ISPB  total_keys pf_keys pj_keys n_key_types
#>    <chr>                            <chr>      <dbl>   <dbl>   <dbl>       <int>
#>  1 NU PAGAMENTOS - IP               1823… 1826857387  1.72e9  1.10e8           5
#>  2 CAIXA ECONOMICA FEDERAL          0036… 1284944190  1.27e9  1.59e7           5
#>  3 PICPAY                           2289…  971013469  9.65e8  5.72e6           5
#>  4 MERCADO PAGO IP LTDA.            1057…  712505886  6.97e8  1.59e7           5
#>  5 BCO BRADESCO S.A.                6074…  572924408  5.49e8  2.37e7           5
#>  6 BANCO INTER                      0041…  558089926  5.31e8  2.74e7           5
#>  7 ITAÚ UNIBANCO S.A.               6070…  499475534  4.70e8  2.99e7           5
#>  8 BCO SANTANDER (BRASIL) S.A.      9040…  407033420  3.83e8  2.38e7           5
#>  9 PAGSEGURO INTERNET IP S.A.       0856…  398858268  3.66e8  3.26e7           5
#> 10 BCO DO BRASIL S.A.               0000…  358119147  3.39e8  1.88e7           5
#> 11 BCO C6 S.A.                      3187…  257673445  2.27e8  3.08e7           5
#> 12 NEON PAGAMENTOS S.A. IP          2085…  219336567  2.17e8  1.90e6           5
#> 13 99PAY IP S.A.                    2431…  198107785  1.98e8  1.63e2           5
#> 14 CLOUDWALK IP LTDA                1818…  134438360  1.16e8  1.82e7           5
#> 15 BANCO PAN                        5928…  125795857  1.26e8  1.37e2           5
#> 16 STONE IP S.A.                    1650…   85309249  6.23e7  2.31e7           5
#> 17 RECARGAPAY IP LTDA.              1127…   80192953  7.84e7  1.79e6           5
#> 18 WILL FINANCEIRA S.A.CFI - EM LI… 2386…   70333099  7.03e7  1   e1           4
#> 19 BCO DO NORDESTE DO BRASIL S.A.   0723…   45725672  4.47e7  1.07e6           5
#> 20 BCO XP S.A.                      3326…   38566472  3.81e7  4.32e5           5

# Get top 10 institutions
get_pix_keys_summary(date = "2025-12-01", n_top = 10)
#> 
#> ── Fetching PIX Keys Summary ──
#> 
#> ── Fetching PIX Keys Stock Data ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/ChavesPix(Data=@Data)?$format=json&@Data='2025-12-01'
#> ✔ Retrieved 61557 records
#> ✔ Returning top 10 institutions
#> # A tibble: 10 × 6
#>    Nome                        ISPB     total_keys   pf_keys pj_keys n_key_types
#>    <chr>                       <chr>         <dbl>     <dbl>   <dbl>       <int>
#>  1 NU PAGAMENTOS - IP          18236120 1826857387    1.72e9  1.10e8           5
#>  2 CAIXA ECONOMICA FEDERAL     00360305 1284944190    1.27e9  1.59e7           5
#>  3 PICPAY                      22896431  971013469    9.65e8  5.72e6           5
#>  4 MERCADO PAGO IP LTDA.       10573521  712505886    6.97e8  1.59e7           5
#>  5 BCO BRADESCO S.A.           60746948  572924408    5.49e8  2.37e7           5
#>  6 BANCO INTER                 00416968  558089926    5.31e8  2.74e7           5
#>  7 ITAÚ UNIBANCO S.A.          60701190  499475534    4.70e8  2.99e7           5
#>  8 BCO SANTANDER (BRASIL) S.A. 90400888  407033420    3.83e8  2.38e7           5
#>  9 PAGSEGURO INTERNET IP S.A.  08561701  398858268    3.66e8  3.26e7           5
#> 10 BCO DO BRASIL S.A.          00000000  358119147    3.39e8  1.88e7           5
```
