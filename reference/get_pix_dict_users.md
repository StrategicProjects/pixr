# Get PIX Users Registered in the DICT

Retrieves the monthly time series of users with at least one PIX key
registered in the Directory of Transactional Account Identifiers (DICT),
broken down by individuals (PF) and legal entities (PJ).

## Usage

``` r
get_pix_dict_users(
  filter = NULL,
  columns = NULL,
  top = NULL,
  orderby = NULL,
  verbose = TRUE
)
```

## Arguments

- filter:

  OData filter expression as a character string. Example:

  - `"qtdUsuariosPessoaFisica gt 150000000"`

- columns:

  Character vector of columns to return. If NULL, returns all columns.
  See "Available Columns" section.

- top:

  Integer; maximum number of records to return.

- orderby:

  Character string specifying the column to sort by. Use `"Column"` for
  ascending or `"Column desc"` for descending order.

- verbose:

  Logical; if TRUE (default), prints progress messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with the DICT registered users time series.

## Details

Unlike the other endpoints, this one takes no reference-date parameter:
it returns the full monthly series in a single request. Use `filter`,
`orderby`, and `top` to narrow the result.

## Available Columns

- DataGraficosPix:

  Reference date (last day of month, YYYY-MM-DD)

- qtdUsuariosPessoaFisica:

  Individual users (PF) registered in DICT

- qtdUsuariosPessoaJuridica:

  Legal entity users (PJ) registered in DICT

- qtdUsuariosCadastradosDICTTotal:

  Total users registered in DICT

## Examples

``` r
# It usually takes much longer than 5 seconds.
# Full monthly series
users <- get_pix_dict_users()
#> 
#> ── Fetching PIX Users Registered in DICT ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/PixUsuariosCadastradosDICT?$format=json
#> ✔ Retrieved 71 records

# Most recent 12 months
recent <- get_pix_dict_users(
  orderby = "DataGraficosPix desc",
  top = 12
)
#> 
#> ── Fetching PIX Users Registered in DICT ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/PixUsuariosCadastradosDICT?$format=json&$orderby=DataGraficosPix%20desc&$top=12
#> ✔ Retrieved 12 records
```
