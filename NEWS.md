# pixr 0.1.0

## Initial Release

* First release of the pixr package

### New Features

* `get_pix_keys()`: Retrieve PIX keys stock by participant
 - Filter by year-month, participant name, or ISPB code
 - Select specific columns
 - Support for ordering and pagination

* `get_pix_transactions_by_municipality()`: Get PIX transactions by municipality
 - Filter by year-month, municipality code, or state
 - Data includes payer and receiver perspectives
 - Breakdown by individuals (PF) and legal entities (PJ)

* `get_pix_transactions_by_state()`: Aggregate transactions by state
 - Convenience wrapper for state-level analysis

* `get_pix_transaction_stats()`: Monthly PIX transaction statistics
 - Filter by specific month or date range
 - Includes transaction count, total value, and average

* `get_pix_growth_stats()`: Calculate growth rates
 - Month-over-month growth
 - Year-over-year growth

### Utilities

* `pix_ping()`: Test API connection
* `pix_query()`: Custom OData queries
* `pix_endpoints()`: List available endpoints
* `pix_columns()`: Get column information for each endpoint
* `year_month_to_date()`: Convert YYYYMM to Date
* `format_brl()`: Format numbers as Brazilian Real currency

### Package Features

* Full OData query parameter support (filter, select, orderby, top, skip)
* Automatic retry with exponential backoff
* Informative progress messages via cli package
* Comprehensive documentation and vignettes
* All functions return tibbles for tidyverse compatibility
