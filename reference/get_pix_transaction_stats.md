# Get PIX Transaction Statistics

Retrieves detailed statistics on PIX transactions settled through the
Instant Payment System (SPI), with breakdowns by payer/receiver type,
region, age group, initiation method, and transaction nature.

## Usage

``` r
get_pix_transaction_stats(
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

  - `"NATUREZA eq 'P2P'"` - Filter by transaction nature

  - `"PAG_REGIAO eq 'SUDESTE'"` - Filter by payer region

  - `"FORMAINICIACAO eq 'DICT'"` - Filter by initiation method

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
with PIX transaction statistics.

## Details

The BCB PIX API requires a `database` parameter specifying which month's
data to retrieve. The data provides granular breakdowns of PIX
transactions.

### Transaction Nature Codes

- **P2P**: Person to Person

- **P2B**: Person to Business

- **B2P**: Business to Person

- **B2B**: Business to Business

- **P2G**: Person to Government

- **G2P**: Government to Person

### Initiation Methods

- **DICT**: PIX Key lookup

- **QRDN**: Dynamic QR Code

- **QRES**: Static QR Code

- **MANU**: Manual entry (bank details)

- **INIC**: Payment Initiator

## Available Columns

- AnoMes:

  Reference year-month as integer (YYYYMM format)

- PAG_PFPJ:

  Payer type: PF (Individual) or PJ (Legal Entity)

- REC_PFPJ:

  Receiver type: PF (Individual) or PJ (Legal Entity)

- PAG_REGIAO:

  Payer region (NORTE, NORDESTE, SUDESTE, SUL, CENTRO-OESTE)

- REC_REGIAO:

  Receiver region

- PAG_IDADE:

  Payer age group

- REC_IDADE:

  Receiver age group

- FORMAINICIACAO:

  Initiation method (DICT, QRDN, QRES, MANU, INIC)

- NATUREZA:

  Transaction nature (P2P, P2B, B2P, B2B, P2G, G2P)

- FINALIDADE:

  Transaction purpose (Pix, Pix Saque, Pix Troco, etc.)

- VALOR:

  Total transaction value (in BRL)

- QUANTIDADE:

  Number of transactions

## Examples

``` r
if (FALSE) { # \dontrun{
# Get transaction statistics for September 2025
stats <- get_pix_transaction_stats(database = "202509")

# Filter by transaction nature
p2p <- get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P'"
)

# Filter by region and order by value
sudeste <- get_pix_transaction_stats(
  database = "202509",
  filter = "PAG_REGIAO eq 'SUDESTE'",
  orderby = "VALOR desc",
  top = 100
)

# Multiple filters (use 'and')
filtered <- get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P' and PAG_REGIAO eq 'NORDESTE'"
)
} # }
```
