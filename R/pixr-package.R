#' pixr: Access Brazilian Central Bank PIX Open Data API
#'
#' @description
#' The pixr package provides a tidyverse-style interface to the Brazilian
#' Central Bank (BCB) PIX Open Data API. It allows you to retrieve statistics
#' on PIX keys, transactions by municipality, transaction breakdowns, and
#' fraud statistics.
#'
#' @section Main Functions:
#'
#' * [get_pix_keys()]: Retrieve PIX keys stock by participant
#' * [get_pix_transactions_by_municipality()]: Get PIX transactions by municipality
#' * [get_pix_transaction_stats()]: Get detailed PIX transaction statistics
#' * [get_pix_fraud_stats()]: Get fraud statistics (MED)
#'
#' @section API Endpoints:
#'
#' The package provides access to 4 endpoints, each with different parameters:
#'
#' | Endpoint | Parameter | Format |
#' |----------|-----------|--------|
#' | ChavesPix | Data | YYYY-MM-DD |
#' | TransacoesPixPorMunicipio | DataBase | YYYYMM |
#' | EstatisticasTransacoesPix | Database | YYYYMM |
#' | EstatisticasFraudesPix | Database | YYYYMM |
#'
#' @section API Information:
#'
#' The PIX Open Data API is provided by the Brazilian Central Bank (Banco Central
#' do Brasil - BCB) through the Olinda platform. The API follows the OData protocol
#' and provides data in JSON, XML, CSV, or HTML formats.
#'
#' Base URL: `https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/`
#'
#' @section Package Options:
#'
#' The following options can be set to customize package behavior:
#'
#' \describe{
#'   \item{pixr.timeout}{Request timeout in seconds. Default is 120 seconds.
#'     The BCB API can be slow for large queries, so a generous timeout is
#'     recommended. Example: `options(pixr.timeout = 180)` for 3 minutes.}
#' }
#'
#' @section Timeout Configuration:
#'
#' The default timeout for API requests is 120 seconds. This can be changed
#' using:
#'
#' ```
#' # Using the helper function
#' pix_timeout(180)  # Set timeout to 3 minutes
#'
#' # Or via options
#' options(pixr.timeout = 180)
#'
#' # Check current timeout
#' pix_timeout()
#' ```
#'
#' @docType package
#' @name pixr-package
#' @aliases pixr
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom rlang .data
## usethis namespace: end
NULL
