# Get PIX Keys by Key Type

Retrieves PIX keys data and returns a summary by key type.

## Usage

``` r
get_pix_keys_by_type(date, verbose = TRUE)
```

## Arguments

- date:

  Character string in "YYYY-MM-DD" format specifying the reference date.
  This parameter is **required**. The API returns data for the last day
  of the specified month.

- verbose:

  Logical; if TRUE (default), prints progress messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with summary data by key type.

## Examples

``` r
# It usually takes much longer than 5 seconds.
# Get summary by key type
get_pix_keys_by_type(date = "2025-12-01")
#> 
#> ── Fetching PIX Keys by Type ──
#> 
#> ── Fetching PIX Keys Stock Data ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/ChavesPix(Data=@Data)?$format=json&@Data='2025-12-01'
#> ✔ Retrieved 55496 records
#> ✔ Summarized by key type
#> # A tibble: 8 × 4
#>   TipoChave NaturezaUsuario total_keys n_institutions
#>   <chr>     <chr>                <dbl>          <int>
#> 1 Aleatória PF              4204403973            837
#> 2 Celular   PF              1428104597            804
#> 3 CPF       PF              1356376191            780
#> 4 e-mail    PF              1202427939            827
#> 5 Aleatória PJ               213745218            868
#> 6 CNPJ      PJ               140590615            814
#> 7 e-mail    PJ                48102123            812
#> 8 Celular   PJ                32058517            740
```
