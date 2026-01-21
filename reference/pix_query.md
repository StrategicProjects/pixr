# Get Raw Data from PIX API

Low-level function to fetch data from any PIX API endpoint with custom
parameters.

## Usage

``` r
pix_query(
  endpoint,
  params = NULL,
  filter = NULL,
  select = NULL,
  orderby = NULL,
  top = NULL,
  skip = NULL,
  format = "json",
  verbose = TRUE
)
```

## Arguments

- endpoint:

  Character string specifying the endpoint name.

- params:

  Named list of endpoint parameters. Each endpoint requires different
  parameters:

  - ChavesPix: `list(Data = "YYYY-MM-DD")`

  - TransacoesPixPorMunicipio: `list(DataBase = "YYYYMM")`

  - EstatisticasTransacoesPix: `list(Database = "YYYYMM")`

  - EstatisticasFraudesPix: `list(Database = "YYYYMM")`

- filter:

  OData filter expression as a character string.

- select:

  Character vector of columns to select.

- orderby:

  OData orderby expression as a character string.

- top:

  Integer; maximum number of records to return.

- skip:

  Integer; number of records to skip.

- format:

  Response format: "json" (default), "xml", "csv", or "html".

- verbose:

  Logical; if TRUE, prints progress messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with the raw API response data.

## Examples

``` r
if (FALSE) # It usually takes much longer than 5 seconds.
# Custom query for keys
pix_query(
  endpoint = "ChavesPix",
  params = list(Data = "2025-12-01"),
  top = 10
)

# Custom query for transaction stats
pix_query(
  endpoint = "EstatisticasTransacoesPix",
  params = list(Database = "202509"),
  top = 10
)
#> 
#> ── Custom PIX API Query ──
#> 
#> ℹ Endpoint: EstatisticasTransacoesPix
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/EstatisticasTransacoesPix(Database=@Database)?$format=json&@Database='202509'&$top=10
#> ✔ Retrieved 10 records
#> # A tibble: 10 × 12
#>    AnoMes PAG_PFPJ REC_PFPJ PAG_REGIAO    REC_REGIAO    PAG_IDADE      REC_IDADE
#>     <int> <chr>    <chr>    <chr>         <chr>         <chr>          <chr>    
#>  1 202511 PF       PJ       SUDESTE       CENTRO-OESTE  entre 30 e 39… Nao se a…
#>  2 202510 PF       PF       Nao informado SUL           entre 40 e 49… entre 20…
#>  3 202509 PJ       PF       NORTE         SUL           Nao se aplica  entre 50…
#>  4 202512 PF       PF       Nao informado CENTRO-OESTE  entre 40 e 49… entre 40…
#>  5 202510 PF       PJ       SUL           Nao informado mais de 60 an… Nao se a…
#>  6 202509 PF       PJ       SUL           SUL           até 19 anos    Nao se a…
#>  7 202511 PF       PF       Nao informado CENTRO-OESTE  entre 30 e 39… entre 30…
#>  8 202511 PF       PF       NORTE         Nao informado até 19 anos    mais de …
#>  9 202510 PF       PF       SUL           NORDESTE      entre 30 e 39… entre 20…
#> 10 202512 PJ       PF       CENTRO-OESTE  NORTE         Nao se aplica  mais de …
#> # ℹ 5 more variables: FORMAINICIACAO <chr>, NATUREZA <chr>, FINALIDADE <chr>,
#> #   VALOR <dbl>, QUANTIDADE <int>
 # \dontrun{}
```
