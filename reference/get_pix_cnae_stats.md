# Get PIX Statistics by Receiver CNAE and Company Size

Retrieves PIX transaction statistics broken down by the receiver's
economic activity (CNAE section), company size, MEI status, initiation
method, and transaction purpose.

## Usage

``` r
get_pix_cnae_stats(
  database,
  filter = NULL,
  columns = NULL,
  top = NULL,
  skip = NULL,
  orderby = NULL,
  verbose = TRUE
)
```

## Arguments

- database:

  Character string in "YYYYMM" format specifying which month's data to
  retrieve. This parameter is **required**.

- filter:

  OData filter expression as a character string. Examples:

  - `"porte eq 'Microempresa'"` - Filter by company size

  - `"mei eq 'S'"` - Only individual microentrepreneurs (MEI)

  - `"tipopessoa eq 'PJ'"` - Filter by receiver person type

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
with PIX statistics by receiver profile.

## Details

The BCB PIX API requires a `database` parameter specifying which month's
data to retrieve. The data profiles the receiving side of PIX
transactions: which economic sectors receive payments, the size of the
receiving companies, and whether the receiver is an individual
microentrepreneur (MEI).

## Available Columns

- AnoMes:

  Reference year-month as integer (YYYYMM format)

- tipopessoa:

  Receiver type: PF (Individual) or PJ (Legal Entity)

- formainic:

  Initiation method (DICT, QRDN, QRES, MANU, INIC)

- finalidade:

  Transaction purpose (Pix, Pix Saque, Pix Troco)

- porte:

  Company size (e.g., Microempresa)

- mei:

  Whether the receiver is an individual microentrepreneur (S/N)

- cnssecao:

  CNAE section of the receiver's economic activity

- mesmatit:

  Whether payer and receiver are the same person (S/N)

- naturezarel:

  Transaction nature (P2P, P2B, B2P, B2B, ...)

- qtpagador:

  Number of distinct payers

- qtrecebedor:

  Number of distinct receivers

- qtlanliq:

  Number of settled transactions

- vllanliq:

  Value of settled transactions (BRL)

- vlcompra:

  Purchase value (BRL, for Pix Troco)

- vldinespec:

  Cash value (BRL, for Pix Saque / Pix Troco)

## Examples

``` r
# It usually takes much longer than 5 seconds.
# Get receiver profile statistics for June 2025
cnae <- get_pix_cnae_stats(database = "202506")
#> 
#> ── Fetching PIX Statistics by Receiver CNAE and Size ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/CnaePorteRecebedor(Database=@Database)?$format=json&@Database='202506'
#> ✔ Retrieved 25055 records

# Only MEI receivers, ordered by value
mei <- get_pix_cnae_stats(
  database = "202506",
  filter = "mei eq 'S'",
  orderby = "vllanliq desc",
  top = 100
)
#> 
#> ── Fetching PIX Statistics by Receiver CNAE and Size ──
#> 
#> ℹ URL: https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/CnaePorteRecebedor(Database=@Database)?$format=json&@Database='202506'&$filter=mei%20eq%20'S'&$orderby=vllanliq%20desc&$top=100
#> ✔ Retrieved 100 records
```
