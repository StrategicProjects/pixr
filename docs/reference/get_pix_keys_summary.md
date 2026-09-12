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
#> ✔ Retrieved 12447 records
#> ✔ Returning top 20 institutions
#> # A tibble: 20 × 6
#>    Nome                             ISPB  total_keys pf_keys pj_keys n_key_types
#>    <chr>                            <chr>      <dbl>   <dbl>   <dbl>       <int>
#>  1 NU PAGAMENTOS - IP               1823…  356895142  3.37e8  2.01e7           5
#>  2 CAIXA ECONOMICA FEDERAL          0036…  250798075  2.48e8  3.22e6           5
#>  3 PICPAY                           2289…  186014251  1.85e8  6.53e5           5
#>  4 MERCADO PAGO IP LTDA.            1057…  125659540  1.23e8  2.75e6           5
#>  5 BCO BRADESCO S.A.                6074…  113141306  1.08e8  4.71e6           5
#>  6 BANCO INTER                      0041…  103906163  9.89e7  4.98e6           5
#>  7 ITAÚ UNIBANCO S.A.               6070…   95725381  9.01e7  5.60e6           5
#>  8 PAGSEGURO INTERNET IP S.A.       0856…   79549381  7.33e7  6.27e6           5
#>  9 BCO SANTANDER (BRASIL) S.A.      9040…   78773888  7.41e7  4.67e6           5
#> 10 BCO DO BRASIL S.A.               0000…   68692220  6.50e7  3.70e6           5
#> 11 BCO C6 S.A.                      3187…   48686881  4.32e7  5.50e6           5
#> 12 NEON PAGAMENTOS S.A. IP          2085…   41950741  4.13e7  6.42e5           5
#> 13 99PAY IP S.A.                    2431…   37217746  3.72e7  2.5 e1           5
#> 14 BANCO PAN                        5928…   24690087  2.47e7  2.6 e1           5
#> 15 CLOUDWALK IP LTDA                1818…   24564881  2.12e7  3.38e6           5
#> 16 WILL FINANCEIRA S.A.CFI - EM LI… 2386…   21998162  2.20e7  2   e0           4
#> 17 STONE IP S.A.                    1650…   15971101  1.18e7  4.16e6           5
#> 18 RECARGAPAY IP LTDA.              1127…   14849738  1.45e7  3.34e5           5
#> 19 BCO DO NORDESTE DO BRASIL S.A.   0723…    8961636  8.76e6  2.06e5           5
#> 20 BCO XP S.A.                      3326…    7046321  6.99e6  6.06e4           5

# Get top 10 institutions
get_pix_keys_summary(date = "2025-12-01", n_top = 10)
#> 
#> ── Fetching PIX Keys Summary ──
#> 
#> ── Fetching PIX Keys Stock Data ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/ChavesPix(Data=@Data)?$format=json&@Data='2025-12-01'
#> ✔ Retrieved 12447 records
#> ✔ Returning top 10 institutions
#> # A tibble: 10 × 6
#>    Nome                        ISPB     total_keys   pf_keys pj_keys n_key_types
#>    <chr>                       <chr>         <dbl>     <dbl>   <dbl>       <int>
#>  1 NU PAGAMENTOS - IP          18236120  356895142 336835637  2.01e7           5
#>  2 CAIXA ECONOMICA FEDERAL     00360305  250798075 247574754  3.22e6           5
#>  3 PICPAY                      22896431  186014251 185361008  6.53e5           5
#>  4 MERCADO PAGO IP LTDA.       10573521  125659540 122912527  2.75e6           5
#>  5 BCO BRADESCO S.A.           60746948  113141306 108435816  4.71e6           5
#>  6 BANCO INTER                 00416968  103906163  98930718  4.98e6           5
#>  7 ITAÚ UNIBANCO S.A.          60701190   95725381  90122668  5.60e6           5
#>  8 PAGSEGURO INTERNET IP S.A.  08561701   79549381  73279502  6.27e6           5
#>  9 BCO SANTANDER (BRASIL) S.A. 90400888   78773888  74103953  4.67e6           5
#> 10 BCO DO BRASIL S.A.          00000000   68692220  64987827  3.70e6           5
```
