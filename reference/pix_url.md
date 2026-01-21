# Build PIX API URL (for debugging)

Builds and returns the URL that would be called by a PIX API function.
Useful for debugging and testing.

## Usage

``` r
pix_url(
  endpoint,
  params = NULL,
  filter = NULL,
  select = NULL,
  orderby = NULL,
  top = NULL,
  skip = NULL,
  format = "json"
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

  OData orderby expression (e.g., "Column asc" or "Column desc").

- top:

  Integer; maximum number of records to return.

- skip:

  Integer; number of records to skip.

- format:

  Response format: "json" (default), "xml", "csv", or "html".

## Value

Character string with the full API URL.

## Examples

``` r
# See what URL would be called for each endpoint
pix_url("ChavesPix", params = list(Data = "2025-12-01"), top = 10)
#> [1] "https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/ChavesPix%28Data%3D%40Data%29?%24format=json&%40Data=%272025-12-01%27&%24top=10"
pix_url("EstatisticasTransacoesPix", params = list(Database = "202509"), top = 10)
#> [1] "https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/EstatisticasTransacoesPix%28Database%3D%40Database%29?%24format=json&%40Database=%27202509%27&%24top=10"
pix_url("TransacoesPixPorMunicipio", params = list(DataBase = "202512"), top = 10)
#> [1] "https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/TransacoesPixPorMunicipio%28DataBase%3D%40DataBase%29?%24format=json&%40DataBase=%27202512%27&%24top=10"
```
