# pixr: Access Brazilian Central Bank PIX Open Data API

The pixr package provides a tidyverse-style interface to the Brazilian
Central Bank (BCB) PIX Open Data API. It allows you to retrieve
statistics on PIX keys, transactions by municipality, transaction
breakdowns, and fraud statistics.

## Main Functions

- [`get_pix_keys()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_keys.md):
  Retrieve PIX keys stock by participant

- [`get_pix_transactions_by_municipality()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_municipality.md):
  Get PIX transactions by municipality

- [`get_pix_transaction_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transaction_stats.md):
  Get detailed PIX transaction statistics

- [`get_pix_fraud_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_fraud_stats.md):
  Get fraud statistics (MED)

## API Endpoints

The package provides access to 4 endpoints, each with different
parameters:

|                           |           |            |
|---------------------------|-----------|------------|
| Endpoint                  | Parameter | Format     |
| ChavesPix                 | Data      | YYYY-MM-DD |
| TransacoesPixPorMunicipio | DataBase  | YYYYMM     |
| EstatisticasTransacoesPix | Database  | YYYYMM     |
| EstatisticasFraudesPix    | Database  | YYYYMM     |

## API Information

The PIX Open Data API is provided by the Brazilian Central Bank (Banco
Central do Brasil - BCB) through the Olinda platform. The API follows
the OData protocol and provides data in JSON, XML, CSV, or HTML formats.

Base URL:
`https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/`

## Package Options

The following options can be set to customize package behavior:

- pixr.timeout:

  Request timeout in seconds. Default is 120 seconds. The BCB API can be
  slow for large queries, so a generous timeout is recommended. Example:
  `options(pixr.timeout = 180)` for 3 minutes.

## Timeout Configuration

The default timeout for API requests is 120 seconds. This can be changed
using:

    # Using the helper function
    pix_timeout(180)  # Set timeout to 3 minutes

    # Or via options
    options(pixr.timeout = 180)

    # Check current timeout
    pix_timeout()

## See also

Useful links:

- <https://github.com/yourname/pixr>

- Report bugs at <https://github.com/yourname/pixr/issues>

## Author

**Maintainer**: Your Name <your.email@example.com>
