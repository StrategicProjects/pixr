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
if (FALSE) # It usually takes much longer than 5 seconds.
# Get top 20 institutions by total keys
get_pix_keys_summary(date = "2025-12-01")

# Get top 10 institutions
get_pix_keys_summary(date = "2025-12-01", n_top = 10)
#> 
#> ── Fetching PIX Keys Summary ──
#> 
#> ── Fetching PIX Keys Stock Data ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/ChavesPix(Data=@Data)?$format=json&@Data='2025-12-01'
#> ✔ Retrieved 55496 records
#> ✔ Returning top 10 institutions
#> # A tibble: 10 × 6
#>    Nome                        ISPB     total_keys   pf_keys pj_keys n_key_types
#>    <chr>                       <chr>         <dbl>     <dbl>   <dbl>       <int>
#>  1 NU PAGAMENTOS - IP          18236120 1639692803    1.54e9  9.83e7           5
#>  2 CAIXA ECONOMICA FEDERAL     00360305 1153236099    1.14e9  1.43e7           5
#>  3 PICPAY                      22896431  869247084    8.64e8  4.87e6           5
#>  4 MERCADO PAGO IP LTDA.       10573521  632442385    6.18e8  1.41e7           5
#>  5 BCO BRADESCO S.A.           60746948  514885521    4.94e8  2.13e7           5
#>  6 BANCO INTER                 00416968  498041416    4.74e8  2.44e7           5
#>  7 ITAÚ UNIBANCO S.A.          60701190  447263450    4.21e8  2.67e7           5
#>  8 BCO SANTANDER (BRASIL) S.A. 90400888  365004115    3.44e8  2.15e7           5
#>  9 PAGSEGURO INTERNET IP S.A.  08561701  359054309    3.30e8  2.92e7           5
#> 10 BCO DO BRASIL S.A.          00000000  320769562    3.04e8  1.70e7           5
 # \dontrun{}
```
