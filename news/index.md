# Changelog

## pixr 0.1.1

### New features

- [`get_pix_cnae_stats()`](https://strategicprojects.github.io/pixr/reference/get_pix_cnae_stats.md):
  access the new `CnaePorteRecebedor` endpoint, with PIX statistics by
  the receiver’s CNAE section, company size, and MEI status.
- [`get_pix_dict_users()`](https://strategicprojects.github.io/pixr/reference/get_pix_dict_users.md):
  access the new `PixUsuariosCadastradosDICT` endpoint, the monthly
  series of users registered in the DICT.
- `pix_columns("fraud")` now documents the full fraud statistics schema
  (24 columns), and
  [`get_pix_fraud_stats()`](https://strategicprojects.github.io/pixr/reference/get_pix_fraud_stats.md)
  validates `columns` against it.
- [`pix_endpoints()`](https://strategicprojects.github.io/pixr/reference/pix_endpoints.md)
  and
  [`pix_ping()`](https://strategicprojects.github.io/pixr/reference/pix_ping.md)
  now cover all six API endpoints.
- New vignette: “Receiver Profiles (CNAE) and DICT Users”
  ([`vignette("receiver-profiles-dict-users")`](https://strategicprojects.github.io/pixr/articles/receiver-profiles-dict-users.md)).

### Authors

- Added ORCID iDs for all authors and aligned the author list with the
  team’s other packages.

### Bug fixes

- Fixed the User-Agent string sent with API requests, which pointed to a
  placeholder GitHub URL instead of the package repository.
- `top` is now validated: non-numeric or non-positive values abort with
  a clear message instead of silently sending `$top=NA` to the API.

### Minor improvements

- [`pix_timeout()`](https://strategicprojects.github.io/pixr/reference/pix_timeout.md)
  now reads the default from the same internal constant used by the
  request builder.
- Added a unit test suite covering the offline helpers (date parsing,
  URL building, column validation, and formatting).
- Removed an unused internal helper (`format_orderby()`).
- `DESCRIPTION` now declares `Language: en-US` and links to the
  documentation site at <https://strategicprojects.github.io/pixr/>.
- Corrected this NEWS file: the 0.1.0 entry listed a function
  (`get_pix_growth_stats()`) that was never part of the package.

## pixr 0.1.0

Initial CRAN release.

### Data access functions

- [`get_pix_keys()`](https://strategicprojects.github.io/pixr/reference/get_pix_keys.md):
  PIX keys stock by participant (DICT), with
  [`get_pix_keys_summary()`](https://strategicprojects.github.io/pixr/reference/get_pix_keys_summary.md)
  and
  [`get_pix_keys_by_type()`](https://strategicprojects.github.io/pixr/reference/get_pix_keys_by_type.md)
  convenience aggregations.
- [`get_pix_transactions_by_municipality()`](https://strategicprojects.github.io/pixr/reference/get_pix_transactions_by_municipality.md):
  PIX transactions by municipality, with
  [`get_pix_transactions_by_state()`](https://strategicprojects.github.io/pixr/reference/get_pix_transactions_by_state.md)
  and
  [`get_pix_transactions_by_region()`](https://strategicprojects.github.io/pixr/reference/get_pix_transactions_by_region.md)
  aggregation wrappers.
- [`get_pix_transaction_stats()`](https://strategicprojects.github.io/pixr/reference/get_pix_transaction_stats.md):
  detailed transaction statistics (payer and receiver type, region, age
  group, initiation method, and nature), with
  [`get_pix_summary()`](https://strategicprojects.github.io/pixr/reference/get_pix_summary.md)
  for grouped aggregations and
  [`get_pix_transaction_stats_multi()`](https://strategicprojects.github.io/pixr/reference/get_pix_transaction_stats_multi.md)
  for multiple months.
- [`get_pix_fraud_stats()`](https://strategicprojects.github.io/pixr/reference/get_pix_fraud_stats.md):
  fraud statistics from the Special Return Mechanism (MED), with
  [`get_pix_fraud_stats_multi()`](https://strategicprojects.github.io/pixr/reference/get_pix_fraud_stats_multi.md)
  for multiple months.

### Utilities

- [`pix_ping()`](https://strategicprojects.github.io/pixr/reference/pix_ping.md):
  test the connection to all API endpoints.
- [`pix_query()`](https://strategicprojects.github.io/pixr/reference/pix_query.md):
  low-level custom OData queries against any endpoint.
- [`pix_url()`](https://strategicprojects.github.io/pixr/reference/pix_url.md):
  build and inspect the request URL without performing it.
- [`pix_endpoints()`](https://strategicprojects.github.io/pixr/reference/pix_endpoints.md)
  and
  [`pix_columns()`](https://strategicprojects.github.io/pixr/reference/pix_columns.md):
  endpoint and column metadata.
- [`pix_timeout()`](https://strategicprojects.github.io/pixr/reference/pix_timeout.md):
  get or set the request timeout (default 120 seconds).
- [`year_month_to_date()`](https://strategicprojects.github.io/pixr/reference/year_month_to_date.md):
  convert `"YYYYMM"` strings to `Date`.
- [`format_brl()`](https://strategicprojects.github.io/pixr/reference/format_brl.md):
  format numbers as Brazilian Real currency.

### Package features

- OData query support (`filter`, `select` via `columns`, `orderby`,
  `top`).
- Automatic retry with exponential backoff and configurable timeout.
- Informative progress messages via the cli package.
- All functions return tibbles for tidyverse compatibility.
