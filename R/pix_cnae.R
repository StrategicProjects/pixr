#' Get PIX Statistics by Receiver CNAE and Company Size
#'
#' @description
#' Retrieves PIX transaction statistics broken down by the receiver's economic
#' activity (CNAE section), company size, MEI status, initiation method, and
#' transaction purpose.
#'
#' @details
#' The BCB PIX API requires a `database` parameter specifying which month's
#' data to retrieve. The data profiles the receiving side of PIX transactions:
#' which economic sectors receive payments, the size of the receiving
#' companies, and whether the receiver is an individual microentrepreneur
#' (MEI).
#'
#' @param database Character string in "YYYYMM" format specifying which month's
#'   data to retrieve. This parameter is **required**.
#' @param filter OData filter expression as a character string. Examples:
#'   - `"porte eq 'Microempresa'"` - Filter by company size
#'   - `"mei eq 'S'"` - Only individual microentrepreneurs (MEI)
#'   - `"tipopessoa eq 'PJ'"` - Filter by receiver person type
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
#'   \item{tipopessoa}{Receiver type: PF (Individual) or PJ (Legal Entity)}
#'   \item{formainic}{Initiation method (DICT, QRDN, QRES, MANU, INIC)}
#'   \item{finalidade}{Transaction purpose (Pix, Pix Saque, Pix Troco)}
#'   \item{porte}{Company size (e.g., Microempresa)}
#'   \item{mei}{Whether the receiver is an individual microentrepreneur (S/N)}
#'   \item{cnssecao}{CNAE section of the receiver's economic activity}
#'   \item{mesmatit}{Whether payer and receiver are the same person (S/N)}
#'   \item{naturezarel}{Transaction nature (P2P, P2B, B2P, B2B, ...)}
#'   \item{qtpagador}{Number of distinct payers}
#'   \item{qtrecebedor}{Number of distinct receivers}
#'   \item{qtlanliq}{Number of settled transactions}
#'   \item{vllanliq}{Value of settled transactions (BRL)}
#'   \item{vlcompra}{Purchase value (BRL, for Pix Troco)}
#'   \item{vldinespec}{Cash value (BRL, for Pix Saque / Pix Troco)}
#' }
#'
#' @return A [tibble::tibble] with PIX statistics by receiver profile.
#'
#' @export
#'
#' @examples
#' \donttest{# It usually takes much longer than 5 seconds.
#' # Get receiver profile statistics for June 2025
#' cnae <- get_pix_cnae_stats(database = "202506")
#'
#' # Only MEI receivers, ordered by value
#' mei <- get_pix_cnae_stats(
#'   database = "202506",
#'   filter = "mei eq 'S'",
#'   orderby = "vllanliq desc",
#'   top = 100
#' )
#' }
get_pix_cnae_stats <- function(database,
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
      "i" = "Specify a year-month in YYYYMM format (e.g., '202506')"
    ))
  }

  if (verbose) {
    cli::cli_h2("Fetching PIX Statistics by Receiver CNAE and Size")
  }

  # Valid columns for this endpoint
  valid_cols <- c(
    "AnoMes", "tipopessoa", "formainic", "finalidade", "porte", "mei",
    "cnssecao", "mesmatit", "naturezarel",
    "qtpagador", "qtrecebedor", "qtlanliq", "vllanliq", "vlcompra", "vldinespec"
  )

  # Validate columns
  columns <- validate_columns(columns, valid_cols)

  # Parse database parameter
  database <- parse_year_month(database)

  # Create and perform request
  req <- pix_request(
    endpoint = "CnaePorteRecebedor",
    params = list(Database = database),
    filter = filter,
    select = columns,
    orderby = orderby,
    top = top,
    skip = skip
  )

  result <- pix_perform(req, verbose = verbose)

  # Clean up data
  result <- clean_cnae_data(result)

  result
}

#' Clean and transform CNAE receiver data
#'
#' @param data Raw data from the API
#' @return Cleaned tibble
#' @noRd
clean_cnae_data <- function(data) {
  if (nrow(data) == 0) {
    return(data)
  }

  # Convert numeric columns
  numeric_cols <- c(
    "AnoMes", "qtpagador", "qtrecebedor", "qtlanliq",
    "vllanliq", "vlcompra", "vldinespec"
  )

  for (col in intersect(numeric_cols, names(data))) {
    data[[col]] <- as.numeric(data[[col]])
  }

  data
}
