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
#> ✔ Retrieved 61557 records
#> ✔ Summarized by key type
#> # A tibble: 8 × 4
#>   TipoChave NaturezaUsuario total_keys n_institutions
#>   <chr>     <chr>                <dbl>          <int>
#> 1 Aleatória PF              4705251946            839
#> 2 Celular   PF              1590807039            808
#> 3 CPF       PF              1510290145            786
#> 4 e-mail    PF              1341675676            829
#> 5 Aleatória PJ               239744782            870
#> 6 CNPJ      PJ               156917010            816
#> 7 e-mail    PJ                53409123            816
#> 8 Celular   PJ                35669898            743
```
