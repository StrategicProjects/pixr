#' @title Utility Functions for pixr
#' @description Helper functions for data transformation and validation
#' @name utils
#' @keywords internal
NULL

#' Get Available PIX API Endpoints
#'
#' @description
#' Returns information about all available endpoints in the BCB PIX Open Data API.
#'
#' @return A [tibble::tibble] with endpoint names, descriptions, parameters,
#'   and associated functions.
#'
#' @export
#'
#' @examples
#' pix_endpoints()
pix_endpoints <- function() {
  tibble::tribble(
    ~endpoint, ~parameter, ~param_format, ~function_name, ~description,
    "ChavesPix", "Data", "YYYY-MM-DD", "get_pix_keys()",
    "PIX keys stock by participant",
    
    "TransacoesPixPorMunicipio", "DataBase", "YYYYMM", "get_pix_transactions_by_municipality()",
    "PIX transactions by municipality",
    
    "EstatisticasTransacoesPix", "Database", "YYYYMM", "get_pix_transaction_stats()",
    "Transaction statistics with breakdowns",
    
    "EstatisticasFraudesPix", "Database", "YYYYMM", "get_pix_fraud_stats()",
    "Fraud statistics (MED)"
  )
}

#' Get Column Information for a PIX Endpoint
#'
#' @description
#' Returns detailed information about the columns available for a specific endpoint.
#'
#' @param endpoint Character string specifying the endpoint. One of:
#'   "keys", "municipality", "stats", or "fraud".
#'
#' @return A [tibble::tibble] with column names, types, and descriptions.
#'
#' @export
#'
#' @examples
#' pix_columns("keys")
#' pix_columns("municipality")
#' pix_columns("stats")
#' pix_columns("fraud")
pix_columns <- function(endpoint = c("keys", "municipality", "stats", "fraud")) {
  endpoint <- match.arg(endpoint)
  
  switch(endpoint,
    keys = tibble::tribble(
      ~column, ~type, ~description,
      "Data", "character", "Reference date (YYYY-MM-DD, last day of month)",
      "ISPB", "character", "8-digit code identifying the financial institution",
      "Nome", "character", "Name of the PIX participant (financial institution)",
      "NaturezaUsuario", "character", "User type: PF (Individual) or PJ (Legal Entity)",
      "TipoChave", "character", "Key type: CPF, CNPJ, Celular, e-mail, or Aleat\u00f3ria",
      "qtdChaves", "numeric", "Number of registered keys"
    ),
    
    municipality = tibble::tribble(
      ~column, ~type, ~description,
      "AnoMes", "integer", "Reference year-month (YYYYMM format)",
      "Municipio_Ibge", "integer", "IBGE municipality code",
      "Municipio", "character", "Municipality name",
      "Estado_Ibge", "integer", "IBGE state code",
      "Estado", "character", "State name",
      "Sigla_Regiao", "character", "Region abbreviation (NE, SE, S, CO, N)",
      "Regiao", "character", "Region name",
      "VL_PagadorPF", "numeric", "Value paid by individuals (BRL)",
      "QT_PagadorPF", "numeric", "Count of transactions with individual payers",
      "VL_PagadorPJ", "numeric", "Value paid by legal entities (BRL)",
      "QT_PagadorPJ", "numeric", "Count of transactions with legal entity payers",
      "VL_RecebedorPF", "numeric", "Value received by individuals (BRL)",
      "QT_RecebedorPF", "numeric", "Count of transactions with individual receivers",
      "VL_RecebedorPJ", "numeric", "Value received by legal entities (BRL)",
      "QT_RecebedorPJ", "numeric", "Count of transactions with legal entity receivers",
      "QT_PES_PagadorPF", "numeric", "Distinct individual payers",
      "QT_PES_PagadorPJ", "numeric", "Distinct legal entity payers",
      "QT_PES_RecebedorPF", "numeric", "Distinct individual receivers",
      "QT_PES_RecebedorPJ", "numeric", "Distinct legal entity receivers"
    ),
    
    stats = tibble::tribble(
      ~column, ~type, ~description,
      "AnoMes", "integer", "Reference year-month (YYYYMM format)",
      "PAG_PFPJ", "character", "Payer type: PF (Individual) or PJ (Legal Entity)",
      "REC_PFPJ", "character", "Receiver type: PF or PJ",
      "PAG_REGIAO", "character", "Payer region (NORTE, NORDESTE, SUDESTE, SUL, CENTRO-OESTE)",
      "REC_REGIAO", "character", "Receiver region",
      "PAG_IDADE", "character", "Payer age group",
      "REC_IDADE", "character", "Receiver age group",
      "FORMAINICIACAO", "character", "Initiation method (DICT, QRDN, QRES, MANU, INIC)",
      "NATUREZA", "character", "Transaction nature (P2P, P2B, B2P, B2B, P2G, G2P)",
      "FINALIDADE", "character", "Transaction purpose (Pix, Pix Saque, Pix Troco)",
      "VALOR", "numeric", "Total transaction value (BRL)",
      "QUANTIDADE", "numeric", "Number of transactions"
    ),
    
    fraud = tibble::tribble(
      ~column, ~type, ~description,
      "AnoMes", "integer", "Reference year-month (YYYYMM format)",
      "(varies)", "varies", "Fraud statistics columns - use API to see full schema"
    )
  )
}

#' Convert Year-Month String to Date
#'
#' @description
#' Converts a year-month string in "YYYYMM" format to a Date object
#' (first day of the month).
#'
#' @param year_month Character vector of year-month strings in "YYYYMM" format.
#'
#' @return A Date vector.
#'
#' @export
#'
#' @examples
#' year_month_to_date("202312")
#' year_month_to_date(c("202301", "202302", "202303"))
year_month_to_date <- function(year_month) {
  if (is.null(year_month)) {
    return(NULL)
  }
  
  # Validate format
  invalid <- !grepl("^\\d{6}$", year_month)
  if (any(invalid)) {
    cli::cli_abort(c(
      "Invalid year_month format",
      "x" = "Invalid values: {.val {year_month[invalid]}}",
      "i" = "Expected format: YYYYMM (e.g., '202312' for December 2023)"
    ))
  }
  
  as.Date(paste0(year_month, "01"), format = "%Y%m%d")
}

#' Format Currency Value
#'
#' @description
#' Formats a numeric value as Brazilian Real (BRL) currency.
#'
#' @param x Numeric vector.
#' @param prefix Logical; if TRUE (default), includes "R$" prefix.
#' @param decimal_mark Character to use as decimal separator.
#' @param big_mark Character to use as thousands separator.
#'
#' @return A character vector with formatted currency values.
#'
#' @export
#'
#' @examples
#' format_brl(1234567.89)
#' format_brl(c(1000, 2000, 3000))
format_brl <- function(x,
                       prefix = TRUE,
                       decimal_mark = ",",
                       big_mark = ".") {
  formatted <- format(
    round(x, 2),
    big.mark = big_mark,
    decimal.mark = decimal_mark,
    scientific = FALSE,
    nsmall = 2
  )
  
  if (prefix) {
    paste0("R$ ", trimws(formatted))
  } else {
    trimws(formatted)
  }
}

#' Check API Connection
#'
#' @description
#' Tests the connection to the BCB PIX Open Data API.
#'
#' @return Logical; TRUE if the API is reachable, FALSE otherwise.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' pix_ping()
#' }
pix_ping <- function() {
  cli::cli_progress_step("Testing connection to BCB PIX API...")
  
  tryCatch({
    req <- pix_request("$metadata")
    resp <- httr2::req_perform(req)
    
    if (httr2::resp_status(resp) == 200) {
      cli::cli_alert_success("API connection successful")
      invisible(TRUE)
    } else {
      cli::cli_alert_danger("API returned status {httr2::resp_status(resp)}")
      invisible(FALSE)
    }
  }, error = function(e) {
    cli::cli_alert_danger("Failed to connect: {conditionMessage(e)}")
    invisible(FALSE)
  })
}

#' Get or Set API Request Timeout
#'
#' @description
#' Get or set the timeout for API requests. The default timeout is 120 seconds.
#' The BCB API can be slow for large queries, so a generous timeout is recommended.
#'
#' @param seconds Integer; timeout in seconds. If NULL, returns the current timeout.
#'
#' @return
#' - `pix_timeout()`: Returns the current timeout in seconds (invisibly when setting).
#' - When called with `seconds`, sets the timeout and returns the new value invisibly.
#'
#' @export
#'
#' @examples
#' # Get current timeout
#' pix_timeout()
#'
#' # Set timeout to 180 seconds (3 minutes)
#' pix_timeout(180)
#'
#' # Set timeout to 60 seconds
#' pix_timeout(60)
#'
#' # Reset to default (120 seconds)
#' pix_timeout(120)
pix_timeout <- function(seconds = NULL) {
  if (is.null(seconds)) {
    # Get current timeout
    timeout <- getOption("pixr.timeout", default = 120)
    return(timeout)
  }
  
 # Validate input
  if (!is.numeric(seconds) || length(seconds) != 1 || seconds <= 0) {
    cli::cli_abort(c(
      "Invalid timeout value",
      "x" = "Got: {.val {seconds}}",
      "i" = "Expected: a positive number (in seconds)"
    ))
  }
  
  # Set new timeout
  options(pixr.timeout = as.integer(seconds))
  
  cli::cli_alert_success("Timeout set to {seconds} seconds")
  
  invisible(seconds)
}

#' Get Raw Data from PIX API
#'
#' @description
#' Low-level function to fetch data from any PIX API endpoint with custom
#' parameters.
#'
#' @param endpoint Character string specifying the endpoint name.
#' @param params Named list of endpoint parameters. Each endpoint requires
#'   different parameters:
#'   - ChavesPix: `list(Data = "YYYY-MM-DD")`
#'   - TransacoesPixPorMunicipio: `list(DataBase = "YYYYMM")`
#'   - EstatisticasTransacoesPix: `list(Database = "YYYYMM")`
#'   - EstatisticasFraudesPix: `list(Database = "YYYYMM")`
#' @param filter OData filter expression as a character string.
#' @param select Character vector of columns to select.
#' @param orderby OData orderby expression as a character string.
#' @param top Integer; maximum number of records to return.
#' @param skip Integer; number of records to skip.
#' @param format Response format: "json" (default), "xml", "csv", or "html".
#' @param verbose Logical; if TRUE, prints progress messages.
#'
#' @return A [tibble::tibble] with the raw API response data.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Custom query for keys
#' pix_query(
#'   endpoint = "ChavesPix",
#'   params = list(Data = "2025-12-01"),
#'   top = 10
#' )
#'
#' # Custom query for transaction stats
#' pix_query(
#'   endpoint = "EstatisticasTransacoesPix",
#'   params = list(Database = "202509"),
#'   top = 10
#' )
#' }
pix_query <- function(endpoint,
                      params = NULL,
                      filter = NULL,
                      select = NULL,
                      orderby = NULL,
                      top = NULL,
                      skip = NULL,
                      format = "json",
                      verbose = TRUE) {
  
  if (verbose) {
    cli::cli_h2("Custom PIX API Query")
    cli::cli_alert_info("Endpoint: {endpoint}")
  }
  
  req <- pix_request(
    endpoint = endpoint,
    params = params,
    format = format,
    filter = filter,
    select = select,
    orderby = orderby,
    top = top,
    skip = skip
  )
  
  pix_perform(req, verbose = verbose)
}

#' Build PIX API URL (for debugging)
#'
#' @description
#' Builds and returns the URL that would be called by a PIX API function.
#' Useful for debugging and testing.
#'
#' @param endpoint Character string specifying the endpoint name.
#' @param params Named list of endpoint parameters. Each endpoint requires
#'   different parameters:
#'   - ChavesPix: `list(Data = "YYYY-MM-DD")`
#'   - TransacoesPixPorMunicipio: `list(DataBase = "YYYYMM")`
#'   - EstatisticasTransacoesPix: `list(Database = "YYYYMM")`
#'   - EstatisticasFraudesPix: `list(Database = "YYYYMM")`
#' @param filter OData filter expression as a character string.
#' @param select Character vector of columns to select.
#' @param orderby OData orderby expression (e.g., "Column asc" or "Column desc").
#' @param top Integer; maximum number of records to return.
#' @param skip Integer; number of records to skip.
#' @param format Response format: "json" (default), "xml", "csv", or "html".
#'
#' @return Character string with the full API URL.
#'
#' @export
#'
#' @examples
#' # See what URL would be called for each endpoint
#' pix_url("ChavesPix", params = list(Data = "2025-12-01"), top = 10)
#' pix_url("EstatisticasTransacoesPix", params = list(Database = "202509"), top = 10)
#' pix_url("TransacoesPixPorMunicipio", params = list(DataBase = "202512"), top = 10)
pix_url <- function(endpoint,
                    params = NULL,
                    filter = NULL,
                    select = NULL,
                    orderby = NULL,
                    top = NULL,
                    skip = NULL,
                    format = "json") {
  
  req <- pix_request(
    endpoint = endpoint,
    params = params,
    format = format,
    filter = filter,
    select = select,
    orderby = orderby,
    top = top,
    skip = skip
  )
  
  req$url
}
