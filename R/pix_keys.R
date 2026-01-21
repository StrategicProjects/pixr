#' Get PIX Keys Stock by Participant
#'
#' @description
#' Retrieves the stock of PIX keys registered in the Directory of Transactional
#' Account Identifiers (DICT) at the end of each month, broken down by PIX
#' participant and key type.
#'
#' @details
#' The BCB PIX API requires a `date` parameter specifying which date's
#' data to retrieve. The data shows the number of PIX keys registered by each
#' financial institution (participant).
#'
#' **Note:** The API returns data for the last day of the month containing
#' the specified date. For example, `date = "2025-12-01"` returns data for
#' `2025-12-31`.
#'
#' @param date Character string in "YYYY-MM-DD" format specifying the reference
#'   date. This parameter is **required**. The API returns data for the last
#'   day of the specified month.
#' @param filter OData filter expression as a character string. Examples:
#'   - `"NaturezaUsuario eq 'PF'"` - Filter by user type (PF or PJ)
#'   - `"TipoChave eq 'CPF'"` - Filter by key type
#'   - `"Nome eq 'BANCO DO BRASIL S.A.'"` - Filter by institution name
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
#'   \item{Data}{Reference date (last day of month, YYYY-MM-DD format)}
#'   \item{ISPB}{8-digit code identifying the financial institution}
#'   \item{Nome}{Name of the PIX participant (financial institution)}
#'   \item{NaturezaUsuario}{User type: PF (Individual) or PJ (Legal Entity)}
#'   \item{TipoChave}{Key type: CPF, CNPJ, Celular, e-mail, or Aleatória}
#'   \item{qtdChaves}{Number of registered keys}
#' }
#'
#' @return A [tibble::tibble] with PIX keys data.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all PIX keys data for December 2025
#' keys <- get_pix_keys(date = "2025-12-01")
#'
#' # Filter by key type and order by quantity
#' cpf_keys <- get_pix_keys(
#'   date = "2025-12-01",
#'   filter = "TipoChave eq 'CPF'",
#'   orderby = "qtdChaves desc",
#'   top = 100
#' )
#'
#' # Filter by institution
#' bb_keys <- get_pix_keys(
#'   date = "2025-12-01",
#'   filter = "Nome eq 'BANCO DO BRASIL S.A.'"
#' )
#' }
get_pix_keys <- function(date,
                         filter = NULL,
                         columns = NULL,
                         top = NULL,
                         skip = NULL,
                         orderby = NULL,
                         verbose = TRUE) {
 
 # Validate required parameter
 if (missing(date) || is.null(date)) {
    cli::cli_abort(c(
      "The {.arg date} parameter is required",
      "i" = "Specify a date in YYYY-MM-DD format (e.g., '2025-12-01')"
    ))
 }
 
 if (verbose) {
    cli::cli_h2("Fetching PIX Keys Stock Data")
 }
 
 # Valid columns for this endpoint
 valid_cols <- c(
    "Data", "ISPB", "Nome", "NaturezaUsuario", "TipoChave", "qtdChaves"
 )
 
 # Validate columns
 columns <- validate_columns(columns, valid_cols)
 
 # Parse and validate date
 date <- parse_date_param(date)
 
 # Create and perform request
 # Note: ChavesPix uses "Data" parameter (not "Database")
 req <- pix_request(
    endpoint = "ChavesPix",
    params = list(Data = date),
    filter = filter,
    select = columns,
    orderby = orderby,
    top = top,
    skip = skip
 )
 
 result <- pix_perform(req, verbose = verbose)
 
 # Clean up data
 result <- clean_pix_keys_data(result)
 
 result
}

#' Parse date parameter for ChavesPix endpoint
#'
#' @param date Date string or Date object
#' @return Character string in YYYY-MM-DD format
#' @noRd
parse_date_param <- function(date) {
 if (is.null(date)) {
    return(NULL)
 }
 
 if (inherits(date, "Date")) {
    return(format(date, "%Y-%m-%d"))
 }
 
 # Convert to character
 date <- as.character(date)
 
 # Validate format YYYY-MM-DD
 if (!grepl("^\\d{4}-\\d{2}-\\d{2}$", date)) {
    cli::cli_abort(c(
      "Invalid date format",
      "x" = "Got: {date}",
      "i" = "Expected format: YYYY-MM-DD (e.g., '2025-12-01')"
    ))
 }
 
 date
}

#' Clean and transform PIX keys data
#'
#' @param data Raw data from the API
#' @return Cleaned tibble
#' @noRd
clean_pix_keys_data <- function(data) {
 if (nrow(data) == 0) {
    return(data)
 }
 
 # Convert numeric columns
 if ("qtdChaves" %in% names(data)) {
    data$qtdChaves <- as.numeric(data$qtdChaves)
 }
 
 data
}

#' Get PIX Keys Summary by Institution
#'
#' @description
#' Retrieves PIX keys data and returns a summary showing total keys by
#' institution, sorted by total keys.
#'
#' @inheritParams get_pix_keys
#' @param n_top Integer; number of top institutions to return. Default is 20.
#'
#' @return A [tibble::tibble] with summary data by institution.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get top 20 institutions by total keys
#' get_pix_keys_summary(date = "2025-12-01")
#'
#' # Get top 10 institutions
#' get_pix_keys_summary(date = "2025-12-01", n_top = 10)
#' }
get_pix_keys_summary <- function(date, n_top = 20, verbose = TRUE) {
 
 if (verbose) {
    cli::cli_h2("Fetching PIX Keys Summary")
 }
 
 data <- get_pix_keys(date = date, verbose = verbose)
 
 if (nrow(data) == 0) {
    return(data)
 }
 
 result <- data |>
    dplyr::group_by(.data$Nome, .data$ISPB) |>
    dplyr::summarise(
      total_keys = sum(.data$qtdChaves, na.rm = TRUE),
      pf_keys = sum(.data$qtdChaves[.data$NaturezaUsuario == "PF"], na.rm = TRUE),
      pj_keys = sum(.data$qtdChaves[.data$NaturezaUsuario == "PJ"], na.rm = TRUE),
      n_key_types = dplyr::n_distinct(.data$TipoChave),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$total_keys)) |>
    dplyr::slice_head(n = n_top)
 
 if (verbose) {
    cli::cli_alert_success("Returning top {n_top} institutions")
 }
 
 result
}

#' Get PIX Keys by Key Type
#'
#' @description
#' Retrieves PIX keys data and returns a summary by key type.
#'
#' @inheritParams get_pix_keys
#'
#' @return A [tibble::tibble] with summary data by key type.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get summary by key type
#' get_pix_keys_by_type(date = "2025-12-01")
#' }
get_pix_keys_by_type <- function(date, verbose = TRUE) {
 
 if (verbose) {
    cli::cli_h2("Fetching PIX Keys by Type")
 }
 
 data <- get_pix_keys(date = date, verbose = verbose)
 
 if (nrow(data) == 0) {
    return(data)
 }
 
 result <- data |>
    dplyr::group_by(.data$TipoChave, .data$NaturezaUsuario) |>
    dplyr::summarise(
      total_keys = sum(.data$qtdChaves, na.rm = TRUE),
      n_institutions = dplyr::n_distinct(.data$ISPB),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$total_keys))
 
 if (verbose) {
    cli::cli_alert_success("Summarized by key type")
 }
 
 result
}
