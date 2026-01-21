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
#> ✔ Retrieved 6252 records
#> ✔ Returning top 10 institutions
#> # A tibble: 10 × 6
#>    Nome                        ISPB     total_keys   pf_keys pj_keys n_key_types
#>    <chr>                       <chr>         <dbl>     <dbl>   <dbl>       <int>
#>  1 NU PAGAMENTOS - IP          18236120  177890202 168042730 9847472           5
#>  2 CAIXA ECONOMICA FEDERAL     00360305  125018141 123408654 1609487           5
#>  3 PICPAY                      22896431   92433894  92138217  295677           5
#>  4 MERCADO PAGO IP LTDA.       10573521   61700653  60360064 1340589           5
#>  5 BCO BRADESCO S.A.           60746948   56439659  54093607 2346052           5
#>  6 BANCO INTER                 00416968   51348818  48905966 2442852           5
#>  7 ITAÚ UNIBANCO S.A.          60701190   47592176  44813457 2778719           5
#>  8 PAGSEGURO INTERNET IP S.A.  08561701   39769897  36658198 3111699           5
#>  9 BCO SANTANDER (BRASIL) S.A. 90400888   39185726  36865130 2320596           5
#> 10 BCO DO BRASIL S.A.          00000000   34136393  32291873 1844520           5
 # \dontrun{}
```
