#' Get PIX Users Registered in the DICT
#'
#' @description
#' Retrieves the monthly time series of users with at least one PIX key
#' registered in the Directory of Transactional Account Identifiers (DICT),
#' broken down by individuals (PF) and legal entities (PJ).
#'
#' @details
#' Unlike the other endpoints, this one takes no reference-date parameter:
#' it returns the full monthly series in a single request. Use `filter`,
#' `orderby`, and `top` to narrow the result.
#'
#' @param filter OData filter expression as a character string. Example:
#'   - `"qtdUsuariosPessoaFisica gt 150000000"`
#' @param columns Character vector of columns to return. If NULL, returns all
#'   columns. See "Available Columns" section.
#' @param top Integer; maximum number of records to return.
#' @param orderby Character string specifying the column to sort by. Use
#'   `"Column"` for ascending or `"Column desc"` for descending order.
#' @param verbose Logical; if TRUE (default), prints progress messages.
#'
#' @section Available Columns:
#' \describe{
#'   \item{DataGraficosPix}{Reference date (last day of month, YYYY-MM-DD)}
#'   \item{qtdUsuariosPessoaFisica}{Individual users (PF) registered in DICT}
#'   \item{qtdUsuariosPessoaJuridica}{Legal entity users (PJ) registered in DICT}
#'   \item{qtdUsuariosCadastradosDICTTotal}{Total users registered in DICT}
#' }
#'
#' @return A [tibble::tibble] with the DICT registered users time series.
#'
#' @export
#'
#' @examples
#' \donttest{# It usually takes much longer than 5 seconds.
#' # Full monthly series
#' users <- get_pix_dict_users()
#'
#' # Most recent 12 months
#' recent <- get_pix_dict_users(
#'   orderby = "DataGraficosPix desc",
#'   top = 12
#' )
#' }
get_pix_dict_users <- function(filter = NULL,
                               columns = NULL,
                               top = NULL,
                               orderby = NULL,
                               verbose = TRUE) {

  if (verbose) {
    cli::cli_h2("Fetching PIX Users Registered in DICT")
  }

  # Valid columns for this endpoint
  valid_cols <- c(
    "DataGraficosPix", "qtdUsuariosPessoaFisica",
    "qtdUsuariosPessoaJuridica", "qtdUsuariosCadastradosDICTTotal"
  )

  # Validate columns
  columns <- validate_columns(columns, valid_cols)

  # Create and perform request (no endpoint parameters)
  req <- pix_request(
    endpoint = "PixUsuariosCadastradosDICT",
    filter = filter,
    select = columns,
    orderby = orderby,
    top = top
  )

  result <- pix_perform(req, verbose = verbose)

  # Clean up data
  result <- clean_dict_users_data(result)

  result
}

#' Clean and transform DICT users data
#'
#' @param data Raw data from the API
#' @return Cleaned tibble
#' @noRd
clean_dict_users_data <- function(data) {
  if (nrow(data) == 0) {
    return(data)
  }

  if ("DataGraficosPix" %in% names(data)) {
    data$DataGraficosPix <- as.Date(data$DataGraficosPix)
  }

  numeric_cols <- c(
    "qtdUsuariosPessoaFisica", "qtdUsuariosPessoaJuridica",
    "qtdUsuariosCadastradosDICTTotal"
  )

  for (col in intersect(numeric_cols, names(data))) {
    data[[col]] <- as.numeric(data[[col]])
  }

  data
}
