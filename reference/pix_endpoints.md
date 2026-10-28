# Get Available PIX API Endpoints

Returns information about all available endpoints in the BCB PIX Open
Data API.

## Usage

``` r
pix_endpoints()
```

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with endpoint names, descriptions, parameters, and associated functions.

## Examples

``` r
pix_endpoints()
#> # A tibble: 6 × 5
#>   endpoint                   parameter param_format function_name    description
#>   <chr>                      <chr>     <chr>        <chr>            <chr>      
#> 1 ChavesPix                  Data      YYYY-MM-DD   get_pix_keys()   PIX keys s…
#> 2 TransacoesPixPorMunicipio  DataBase  YYYYMM       get_pix_transac… PIX transa…
#> 3 EstatisticasTransacoesPix  Database  YYYYMM       get_pix_transac… Transactio…
#> 4 EstatisticasFraudesPix     Database  YYYYMM       get_pix_fraud_s… Fraud stat…
#> 5 CnaePorteRecebedor         Database  YYYYMM       get_pix_cnae_st… Statistics…
#> 6 PixUsuariosCadastradosDICT NA        NA           get_pix_dict_us… Monthly se…
```
