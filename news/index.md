# Changelog

## pixr 0.1.0

### Initial Release

- First release of the pixr package

#### New Features

- [`get_pix_keys()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_keys.md):
  Retrieve PIX keys stock by participant

- Filter by year-month, participant name, or ISPB code

- Select specific columns

- Support for ordering and pagination

- [`get_pix_transactions_by_municipality()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_municipality.md):
  Get PIX transactions by municipality

- Filter by year-month, municipality code, or state

- Data includes payer and receiver perspectives

- Breakdown by individuals (PF) and legal entities (PJ)

- [`get_pix_transactions_by_state()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transactions_by_state.md):
  Aggregate transactions by state

- Convenience wrapper for state-level analysis

- [`get_pix_transaction_stats()`](https://monitoramento.pe.gov.br/pixr/reference/get_pix_transaction_stats.md):
  Monthly PIX transaction statistics

- Filter by specific month or date range

- Includes transaction count, total value, and average

- `get_pix_growth_stats()`: Calculate growth rates

- Month-over-month growth

- Year-over-year growth

#### Utilities

- [`pix_ping()`](https://monitoramento.pe.gov.br/pixr/reference/pix_ping.md):
  Test API connection
- [`pix_query()`](https://monitoramento.pe.gov.br/pixr/reference/pix_query.md):
  Custom OData queries
- [`pix_endpoints()`](https://monitoramento.pe.gov.br/pixr/reference/pix_endpoints.md):
  List available endpoints
- [`pix_columns()`](https://monitoramento.pe.gov.br/pixr/reference/pix_columns.md):
  Get column information for each endpoint
- [`year_month_to_date()`](https://monitoramento.pe.gov.br/pixr/reference/year_month_to_date.md):
  Convert YYYYMM to Date
- [`format_brl()`](https://monitoramento.pe.gov.br/pixr/reference/format_brl.md):
  Format numbers as Brazilian Real currency

#### Package Features

- Full OData query parameter support (filter, select, orderby, top,
  skip)
- Automatic retry with exponential backoff
- Informative progress messages via cli package
- Comprehensive documentation and vignettes
- All functions return tibbles for tidyverse compatibility
