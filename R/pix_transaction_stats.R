#' Get PIX Transaction Statistics
#'
#' @description
#' Retrieves detailed statistics on PIX transactions settled through the
#' Instant Payment System (SPI), with breakdowns by payer/receiver type,
#' region, age group, initiation method, and transaction nature.
#'
#' @details
#' The BCB PIX API requires a `database` parameter specifying which month's
#' data to retrieve. The data provides granular breakdowns of PIX transactions.
#'
#' ## Transaction Nature Codes
#' - **P2P**: Person to Person
#' - **P2B**: Person to Business
#' - **B2P**: Business to Person
#' - **B2B**: Business to Business
#' - **P2G**: Person to Government
#' - **G2P**: Government to Person
#'
#' ## Initiation Methods
#' - **DICT**: PIX Key lookup
#' - **QRDN**: Dynamic QR Code
#' - **QRES**: Static QR Code
#' - **MANU**: Manual entry (bank details)
#' - **INIC**: Payment Initiator
#'
#' @param database Character string in "YYYYMM" format specifying which month's
#'   data to retrieve. This parameter is **required**.
#' @param filter OData filter expression as a character string. Examples:
#'   - `"NATUREZA eq 'P2P'"` - Filter by transaction nature
#'   - `"PAG_REGIAO eq 'SUDESTE'"` - Filter by payer region
#'   - `"FORMAINICIACAO eq 'DICT'"` - Filter by initiation method
#' @param columns Character vector of columns to return. If NULL, returns all
#'   columns. See "Available Columns" section.
#' @param top Integer; maximum number of records to return.
#' @param skip Integer; number of records to skip (for pagination).
#' @param orderby Character string specifying the column to sort by. Use
#'   `"Column"` for ascending or `"Column desc"` for descending order.
#' @param verbose Logical; if TRUE (default), prints progress messages.
#'
#' @section Available Columns:
#' \describe{
#'   \item{AnoMes}{Reference year-month as integer (YYYYMM format)}
#'   \item{PAG_PFPJ}{Payer type: PF (Individual) or PJ (Legal Entity)}
#'   \item{REC_PFPJ}{Receiver type: PF (Individual) or PJ (Legal Entity)}
#'   \item{PAG_REGIAO}{Payer region (NORTE, NORDESTE, SUDESTE, SUL, CENTRO-OESTE)}
#'   \item{REC_REGIAO}{Receiver region}
#'   \item{PAG_IDADE}{Payer age group}
#'   \item{REC_IDADE}{Receiver age group}
#'   \item{FORMAINICIACAO}{Initiation method (DICT, QRDN, QRES, MANU, INIC)}
#'   \item{NATUREZA}{Transaction nature (P2P, P2B, B2P, B2B, P2G, G2P)}
#'   \item{FINALIDADE}{Transaction purpose (Pix, Pix Saque, Pix Troco, etc.)}
#'   \item{VALOR}{Total transaction value (in BRL)}
#'   \item{QUANTIDADE}{Number of transactions}
#' }
#'
#' @return A [tibble::tibble] with PIX transaction statistics.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get transaction statistics for September 2025
#' stats <- get_pix_transaction_stats(database = "202509")
#'
#' # Filter by transaction nature
#' p2p <- get_pix_transaction_stats(
#'   database = "202509",
#'   filter = "NATUREZA eq 'P2P'"
#' )
#'
#' # Filter by region and order by value
#' sudeste <- get_pix_transaction_stats(
#'   database = "202509",
#'   filter = "PAG_REGIAO eq 'SUDESTE'",
#'   orderby = "VALOR desc",
#'   top = 100
#' )
#'
#' # Multiple filters (use 'and')
#' filtered <- get_pix_transaction_stats(
#'   database = "202509",
#'   filter = "NATUREZA eq 'P2P' and PAG_REGIAO eq 'NORDESTE'"
#' )
#' }
get_pix_transaction_stats <- function(database,
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
    cli::cli_h2("Fetching PIX Transaction Statistics")
  }
  
  # Valid columns for this endpoint
  valid_cols <- c(
    "AnoMes", "PAG_PFPJ", "REC_PFPJ", "PAG_REGIAO", "REC_REGIAO",
    "PAG_IDADE", "REC_IDADE", "FORMAINICIACAO", "NATUREZA",
    "FINALIDADE", "VALOR", "QUANTIDADE"
  )
  
  # Validate columns
  columns <- validate_columns(columns, valid_cols)
  
  # Parse database parameter
  database <- parse_year_month(database)
  
  # Create and perform request
  # Note: EstatisticasTransacoesPix uses "Database" parameter (lowercase b)
  req <- pix_request(
    endpoint = "EstatisticasTransacoesPix",
    params = list(Database = database),
    filter = filter,
    select = columns,
    orderby = orderby,
    top = top,
    skip = skip
  )
  
  result <- pix_perform(req, verbose = verbose)
  
  # Convert numeric columns
  result <- clean_stats_data(result)
  
  result
}

#' Clean and transform transaction statistics data
#'
#' @param data Raw data from the API
#' @return Cleaned tibble
#' @noRd
clean_stats_data <- function(data) {
  if (nrow(data) == 0) {
    return(data)
  }
  
  # Convert numeric columns
  numeric_cols <- c("AnoMes", "VALOR", "QUANTIDADE")
  
  for (col in intersect(numeric_cols, names(data))) {
    data[[col]] <- as.numeric(data[[col]])
  }
  
  data
}

#' Get PIX Transaction Summary
#'
#' @description
#' Retrieves transaction statistics and aggregates them by specified grouping
#' variables. This is a convenience function that fetches data and performs
#' common aggregations.
#'
#' @inheritParams get_pix_transaction_stats
#' @param group_by Character vector of columns to group by. Common choices:
#'   "NATUREZA", "PAG_REGIAO", "REC_REGIAO", "FORMAINICIACAO".
#'
#' @return A [tibble::tibble] with aggregated transaction statistics.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Summary by transaction nature
#' get_pix_summary(database = "202509", group_by = "NATUREZA")
#'
#' # Summary by payer region
#' get_pix_summary(database = "202509", group_by = "PAG_REGIAO")
#'
#' # Summary by nature and initiation method
#' get_pix_summary(database = "202509", group_by = c("NATUREZA", "FORMAINICIACAO"))
#' }
get_pix_summary <- function(database,
                            group_by = "NATUREZA",
                            verbose = TRUE) {
  
  if (verbose) {
    cli::cli_h2("Fetching PIX Transaction Summary")
  }
  
  # Get raw data
  data <- get_pix_transaction_stats(database = database, verbose = verbose)
  
  if (nrow(data) == 0) {
    return(data)
  }
  
  # Aggregate
  group_syms <- rlang::syms(group_by)
  
  result <- data |>
    dplyr::group_by(!!!group_syms) |>
    dplyr::summarise(
      total_value = sum(.data$VALOR, na.rm = TRUE),
      total_count = sum(.data$QUANTIDADE, na.rm = TRUE),
      avg_value = sum(.data$VALOR, na.rm = TRUE) / sum(.data$QUANTIDADE, na.rm = TRUE),
      n_records = dplyr::n(),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$total_value))
  
  if (verbose) {
    cli::cli_alert_success("Aggregated into {nrow(result)} groups")
  }
  
  result
}

#' Get PIX Transaction Statistics for Multiple Months
#'
#' @description
#' Retrieves transaction statistics for multiple months and combines them
#' into a single tibble.
#'
#' @param databases Character vector of year-months in "YYYYMM" format.
#' @param ... Additional arguments passed to [get_pix_transaction_stats()].
#'
#' @return A [tibble::tibble] with combined transaction statistics.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get data for Q3 2025
#' q3_data <- get_pix_transaction_stats_multi(
#'   databases = c("202507", "202508", "202509")
#' )
#' }
get_pix_transaction_stats_multi <- function(databases, ...) {
  
  cli::cli_h2("Fetching PIX Statistics for Multiple Months")
  cli::cli_alert_info("Months: {paste(databases, collapse = ', ')}")
  
  results <- purrr::map(databases, function(db) {
    cli::cli_progress_step("Fetching {db}...")
    tryCatch(
      get_pix_transaction_stats(database = db, verbose = FALSE, ...),
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
