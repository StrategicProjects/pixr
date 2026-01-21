# Package index

## PIX Keys Data

Functions to retrieve PIX keys statistics from the DICT (Directory of
Transactional Account Identifiers).

- [`get_pix_keys()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_keys.md)
  : Get PIX Keys Stock by Participant
- [`get_pix_keys_summary()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_keys_summary.md)
  : Get PIX Keys Summary by Institution
- [`get_pix_keys_by_type()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_keys_by_type.md)
  : Get PIX Keys by Key Type

## PIX Transactions by Municipality

Functions to retrieve PIX transaction statistics aggregated by
municipality, state, or region.

- [`get_pix_transactions_by_municipality()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_municipality.md)
  : Get PIX Transactions by Municipality
- [`get_pix_transactions_by_state()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_state.md)
  : Get PIX Transactions by State
- [`get_pix_transactions_by_region()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_region.md)
  : Get PIX Transactions by Region

## PIX Transaction Statistics

Functions to retrieve detailed PIX transaction statistics with
breakdowns by type, region, and demographics.

- [`get_pix_transaction_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transaction_stats.md)
  : Get PIX Transaction Statistics
- [`get_pix_summary()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_summary.md)
  : Get PIX Transaction Summary
- [`get_pix_transaction_stats_multi()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transaction_stats_multi.md)
  : Get PIX Transaction Statistics for Multiple Months

## PIX Fraud Statistics

Functions to retrieve PIX fraud statistics from the Special Return
Mechanism (MED).

- [`get_pix_fraud_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_fraud_stats.md)
  : Get PIX Fraud Statistics (MED)
- [`get_pix_fraud_stats_multi()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_fraud_stats_multi.md)
  : Get PIX Fraud Statistics for Multiple Months

## API Utilities

Utility functions for working with the BCB PIX Open Data API, including
connection testing, custom queries, and debugging.

- [`pix_ping()`](https://monitoramento.pe.gov.br/pixr/reference/pix_ping.md)
  : Check API Connection
- [`pix_query()`](https://monitoramento.pe.gov.br/pixr/reference/pix_query.md)
  : Get Raw Data from PIX API
- [`pix_url()`](https://monitoramento.pe.gov.br/pixr/reference/pix_url.md)
  : Build PIX API URL (for debugging)
- [`pix_endpoints()`](https://monitoramento.pe.gov.br/pixr/reference/pix_endpoints.md)
  : Get Available PIX API Endpoints
- [`pix_columns()`](https://monitoramento.pe.gov.br/pixr/reference/pix_columns.md)
  : Get Column Information for a PIX Endpoint
- [`pix_timeout()`](https://monitoramento.pe.gov.br/pixr/reference/pix_timeout.md)
  : Get or Set API Request Timeout

## Data Helpers

Helper functions for data transformation and formatting.

- [`year_month_to_date()`](https://monitoramento.pe.gov.br/pixr/reference/year_month_to_date.md)
  : Convert Year-Month String to Date
- [`format_brl()`](https://monitoramento.pe.gov.br/pixr/reference/format_brl.md)
  : Format Currency Value
