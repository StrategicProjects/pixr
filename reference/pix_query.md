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
if (FALSE) { # \dontrun{
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
} # }
```
