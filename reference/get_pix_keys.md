# Get PIX Keys Stock by Participant

Retrieves the stock of PIX keys registered in the Directory of
Transactional Account Identifiers (DICT) at the end of each month,
broken down by PIX participant and key type.

## Usage

``` r
get_pix_keys(
  date,
  filter = NULL,
  columns = NULL,
  top = NULL,
  skip = NULL,
  orderby = NULL,
  verbose = TRUE
)
```

## Arguments

- date:

  Character string in "YYYY-MM-DD" format specifying the reference date.
  This parameter is **required**. The API returns data for the last day
  of the specified month.

- filter:

  OData filter expression as a character string. Examples:

  - `"NaturezaUsuario eq 'PF'"` - Filter by user type (PF or PJ)

  - `"TipoChave eq 'CPF'"` - Filter by key type

  - `"Nome eq 'BANCO DO BRASIL S.A.'"` - Filter by institution name

- columns:

  Character vector of columns to return. If NULL, returns all columns.
  See "Available Columns" section.

- top:

  Integer; maximum number of records to return.

- skip:

  Integer; number of records to skip (for pagination).

- orderby:

  Character string specifying the column to sort by. Use `"Column"` for
  ascending or `"Column desc"` for descending order.

- verbose:

  Logical; if TRUE (default), prints progress messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with PIX keys data.

## Details

The BCB PIX API requires a `date` parameter specifying which date's data
to retrieve. The data shows the number of PIX keys registered by each
financial institution (participant).

**Note:** The API returns data for the last day of the month containing
the specified date. For example, `date = "2025-12-01"` returns data for
`2025-12-31`.

## Available Columns

- Data:

  Reference date (last day of month, YYYY-MM-DD format)

- ISPB:

  8-digit code identifying the financial institution

- Nome:

  Name of the PIX participant (financial institution)

- NaturezaUsuario:

  User type: PF (Individual) or PJ (Legal Entity)

- TipoChave:

  Key type: CPF, CNPJ, Celular, e-mail, or Aleatória

- qtdChaves:

  Number of registered keys

## Examples

``` r
if (FALSE) # It usually takes much longer than 5 seconds.
# Get all PIX keys data for December 2025
keys <- get_pix_keys(date = "2025-12-01")

# Filter by key type and order by quantity
cpf_keys <- get_pix_keys(
  date = "2025-12-01",
  filter = "TipoChave eq 'CPF'",
  orderby = "qtdChaves desc",
  top = 100
)
#> 
#> ── Fetching PIX Keys Stock Data ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/ChavesPix(Data=@Data)?$format=json&@Data='2025-12-01'&$filter=TipoChave%20eq%20'CPF'&$orderby=qtdChaves%20desc&$top=100
#> ✔ Retrieved 100 records

# Filter by institution
bb_keys <- get_pix_keys(
  date = "2025-12-01",
  filter = "Nome eq 'BANCO DO BRASIL S.A.'"
)
#> 
#> ── Fetching PIX Keys Stock Data ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/ChavesPix(Data=@Data)?$format=json&@Data='2025-12-01'&$filter=Nome%20eq%20'BANCO%20DO%20BRASIL%20S.A.'
#> ! No data returned from API
 # \dontrun{}
```
