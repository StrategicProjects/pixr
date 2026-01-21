#' Get PIX Fraud Statistics (MED)
#'
#' @description
#' Retrieves fraud statistics for PIX transactions reported through the
#' Special Return Mechanism (MED - Mecanismo Especial de Devolução).
#'
#' @details
#' The MED (Mecanismo Especial de Devolução) is a mechanism created by the
#' Brazilian Central Bank to facilitate the return of funds in cases of
#' fraud or operational errors in PIX transactions.
#'
#' This endpoint provides statistics on:
#' - Number of fraud reports (notificações de infração)
#' - Number of return requests (pedidos de devolução)
#' - Values involved in fraud cases
#'
#' @param database Character string in "YYYYMM" format specifying which month's
#'   data to retrieve. This parameter is **required**.
#' @param filter OData filter expression as a character string.
#' @param columns Character vector of columns to return. If NULL, returns all
#'   columns.
#' @param top Integer; maximum number of records to return.
#' @param skip Integer; number of records to skip (for pagination).
#' @param orderby Character string specifying the column to sort by. Use
#'   `"Column"` for ascending or `"Column desc"` for descending order.
#' @param verbose Logical; if TRUE (default), prints progress messages.
#'
#' @return A [tibble::tibble] with PIX fraud statistics.
#'
#' @export
#'
#' @examples
#' \dontrun{# It usually takes much longer than 5 seconds.
#' # Get fraud statistics for September 2025
#' fraud <- get_pix_fraud_stats(database = "202509")
#'
#' # Get top 100 records
#' fraud <- get_pix_fraud_stats(database = "202509", top = 100)
#' }
get_pix_fraud_stats <- function(database,
                                 filter = NULL,
                                 columns = NULL,
                                 top = NULL,
                                 skip = NULL,
                                 orderby = NULL,
                                 verbose = TRUE) {
  
  # Validate required parameter
  if (missing(database) || is.null(database)) {
    cli::cli_abort(c(
      "The {.arg database} parameter is required",
      "i" = "Specify a year-month in YYYYMM format (e.g., '202509')"
    ))
  }
  
  if (verbose) {
    cli::cli_h2("Fetching PIX Fraud Statistics (MED)")
  }
  
  # Parse database parameter
  database <- parse_year_month(database)
  
  # Create and perform request
  # Note: EstatisticasFraudesPix uses "Database" parameter
  req <- pix_request(
    endpoint = "EstatisticasFraudesPix",
    params = list(Database = database),
    filter = filter,
    select = columns,
    orderby = orderby,
    top = top,
    skip = skip
  )
  
  result <- pix_perform(req, verbose = verbose)
  
  # Clean up data - convert numeric columns
  result <- clean_fraud_data(result)
  
  result
}

#' Clean and transform fraud statistics data
#'
#' @param data Raw data from the API
#' @return Cleaned tibble
#' @noRd
clean_fraud_data <- function(data) {
  if (nrow(data) == 0) {
    return(data)
  }
  
  # Convert any numeric columns (will depend on actual API response)
  # Common numeric patterns
  numeric_patterns <- c("QT_", "VL_", "QUANTIDADE", "VALOR", "AnoMes")
  
  for (col in names(data)) {
    if (any(sapply(numeric_patterns, function(p) grepl(p, col, ignore.case = TRUE)))) {
      data[[col]] <- as.numeric(data[[col]])
    }
  }
  
  data
}

#' Get PIX Fraud Statistics for Multiple Months
#'
#' @description
#' Retrieves fraud statistics for multiple months and combines them
#' into a single tibble.
#'
#' @param databases Character vector of year-months in "YYYYMM" format.
#' @param ... Additional arguments passed to [get_pix_fraud_stats()].
#'
#' @return A [tibble::tibble] with combined fraud statistics.
#'
#' @export
#'
#' @examples
#' \dontrun{# It usually takes much longer than 5 seconds.
#' # Get fraud data for Q3 2025
#' q3_fraud <- get_pix_fraud_stats_multi(
#'   databases = c("202507", "202508", "202509")
#' )
#' }
get_pix_fraud_stats_multi <- function(databases, ...) {
  
  cli::cli_h2("Fetching PIX Fraud Statistics for Multiple Months")
  cli::cli_alert_info("Months: {paste(databases, collapse = ', ')}")
  
  results <- purrr::map(databases, function(db) {
    cli::cli_alert_info("Fetching {db}...")
    tryCatch(
      get_pix_fraud_stats(database = db, verbose = FALSE, ...),
      error = function(e) {
        cli::cli_alert_warning("Failed to fetch {db}: {conditionMessage(e)}")
        tibble::tibble()
      }
    )
  })
  
  combined <- dplyr::bind_rows(results)
  
  cli::cli_alert_success("Retrieved {nrow(combined)} total records from {length(databases)} months")
  
  combined
}
