#' Get PIX Transactions by Municipality
#'
#' @description
#' Retrieves PIX transaction statistics aggregated by municipality, showing
#' the number and value of transactions from the perspective of both payers
#' and receivers.
#'
#' @details
#' The BCB PIX API requires a `database` parameter (YYYYMM format) specifying
#' which month's data to retrieve. The data is broken down by municipality,
#' person type (PF/PJ), and transaction direction (payer/receiver).
#'
#' @param database Character string in "YYYYMM" format specifying which month's
#'   data to retrieve. This parameter is **required**.
#' @param filter OData filter expression as a character string. Examples:
#'   - `"Estado eq 'SÃO PAULO'"` - Filter by state name
#'   - `"Sigla_Regiao eq 'SE'"` - Filter by region
#'   - `"Municipio eq 'RECIFE'"` - Filter by municipality name
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
#'   \item{AnoMes}{Reference year-month in YYYYMM format}
#'   \item{Municipio_Ibge}{IBGE municipality code}
#'   \item{Municipio}{Municipality name}
#'   \item{Estado_Ibge}{IBGE state code}
#'   \item{Estado}{State name}
#'   \item{Sigla_Regiao}{Region abbreviation (NE, SE, S, CO, N)}
#'   \item{Regiao}{Region name (NORDESTE, SUDESTE, SUL, CENTRO-OESTE, NORTE)}
#'   \item{VL_PagadorPF}{Total value paid by individuals (BRL)}
#'   \item{QT_PagadorPF}{Number of transactions where individuals were payers}
#'   \item{VL_PagadorPJ}{Total value paid by legal entities (BRL)}
#'   \item{QT_PagadorPJ}{Number of transactions where legal entities were payers}
#'   \item{VL_RecebedorPF}{Total value received by individuals (BRL)}
#'   \item{QT_RecebedorPF}{Number of transactions where individuals were receivers}
#'   \item{VL_RecebedorPJ}{Total value received by legal entities (BRL)}
#'   \item{QT_RecebedorPJ}{Number of transactions where legal entities were receivers}
#'   \item{QT_PES_PagadorPF}{Number of distinct individual payers}
#'   \item{QT_PES_PagadorPJ}{Number of distinct legal entity payers}
#'   \item{QT_PES_RecebedorPF}{Number of distinct individual receivers}
#'   \item{QT_PES_RecebedorPJ}{Number of distinct legal entity receivers}
#' }
#'
#' @return A [tibble::tibble] with PIX transaction data by municipality.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get municipality transaction data for December 2025
#' muni <- get_pix_transactions_by_municipality(database = "202512")
#'
#' # Filter by state
#' maranhao <- get_pix_transactions_by_municipality(
#'   database = "202512",
#'   filter = "Estado eq 'MARANHÃO'",
#'   orderby = "Municipio desc",
#'   top = 10
#' )
#'
#' # Filter by region
#' nordeste <- get_pix_transactions_by_municipality(
#'   database = "202512",
#'   filter = "Sigla_Regiao eq 'NE'"
#' )
#'
#' # Order by value
#' top_value <- get_pix_transactions_by_municipality(
#'   database = "202512",
#'   orderby = "VL_PagadorPF desc",
#'   top = 100
#' )
#' }
get_pix_transactions_by_municipality <- function(database,
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
      "i" = "Specify a year-month in YYYYMM format (e.g., '202512')"
    ))
  }
  
  if (verbose) {
    cli::cli_h2("Fetching PIX Transactions by Municipality")
  }
  
  # Valid columns for this endpoint
  valid_cols <- c(
    "AnoMes", "Municipio_Ibge", "Municipio", "Estado_Ibge", "Estado",
    "Sigla_Regiao", "Regiao",
    "VL_PagadorPF", "QT_PagadorPF", "VL_PagadorPJ", "QT_PagadorPJ",
    "VL_RecebedorPF", "QT_RecebedorPF", "VL_RecebedorPJ", "QT_RecebedorPJ",
    "QT_PES_PagadorPF", "QT_PES_PagadorPJ", "QT_PES_RecebedorPF", "QT_PES_RecebedorPJ"
  )
  
  # Validate columns
  columns <- validate_columns(columns, valid_cols)
  
  # Parse database parameter
  database <- parse_year_month(database)
  
  # Create and perform request
  # Note: TransacoesPixPorMunicipio uses "DataBase" parameter (capital B)
  req <- pix_request(
    endpoint = "TransacoesPixPorMunicipio",
    params = list(DataBase = database),
    filter = filter,
    select = columns,
    orderby = orderby,
    top = top,
    skip = skip
  )
  
  result <- pix_perform(req, verbose = verbose)
  
  # Clean up data
  result <- clean_municipality_data(result)
  
  result
}

#' Clean and transform municipality transaction data
#'
#' @param data Raw data from the API
#' @return Cleaned tibble
#' @noRd
clean_municipality_data <- function(data) {
  if (nrow(data) == 0) {
    return(data)
  }
  
  # Convert numeric columns
  numeric_cols <- c(
    "AnoMes", "Municipio_Ibge", "Estado_Ibge",
    "VL_PagadorPF", "QT_PagadorPF", "VL_PagadorPJ", "QT_PagadorPJ",
    "VL_RecebedorPF", "QT_RecebedorPF", "VL_RecebedorPJ", "QT_RecebedorPJ",
    "QT_PES_PagadorPF", "QT_PES_PagadorPJ", "QT_PES_RecebedorPF", "QT_PES_RecebedorPJ"
  )
  
  for (col in intersect(numeric_cols, names(data))) {
    data[[col]] <- as.numeric(data[[col]])
  }
  
  data
}

#' Get PIX Transactions by State
#'
#' @description
#' A convenience wrapper around [get_pix_transactions_by_municipality()] that
#' aggregates data at the state level.
#'
#' @inheritParams get_pix_transactions_by_municipality
#'
#' @return A [tibble::tibble] with PIX transaction data aggregated by state.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get state-level aggregates for December 2025
#' states <- get_pix_transactions_by_state(database = "202512")
#' }
get_pix_transactions_by_state <- function(database, verbose = TRUE) {
  
  if (verbose) {
    cli::cli_h2("Fetching PIX Transactions by State")
  }
  
  data <- get_pix_transactions_by_municipality(
    database = database,
    verbose = verbose
  )
  
  if (nrow(data) == 0) {
    return(data)
  }
  
  # Aggregate by state
  result <- data |>
    dplyr::group_by(
      .data$AnoMes, .data$Estado_Ibge, .data$Estado,
      .data$Sigla_Regiao, .data$Regiao
    ) |>
    dplyr::summarise(
      n_municipalities = dplyr::n(),
      vl_pagador_pf = sum(.data$VL_PagadorPF, na.rm = TRUE),
      qt_pagador_pf = sum(.data$QT_PagadorPF, na.rm = TRUE),
      vl_pagador_pj = sum(.data$VL_PagadorPJ, na.rm = TRUE),
      qt_pagador_pj = sum(.data$QT_PagadorPJ, na.rm = TRUE),
      vl_recebedor_pf = sum(.data$VL_RecebedorPF, na.rm = TRUE),
      qt_recebedor_pf = sum(.data$QT_RecebedorPF, na.rm = TRUE),
      vl_recebedor_pj = sum(.data$VL_RecebedorPJ, na.rm = TRUE),
      qt_recebedor_pj = sum(.data$QT_RecebedorPJ, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$vl_pagador_pf))
  
  if (verbose) {
    cli::cli_alert_success("Aggregated data for {nrow(result)} state{?s}")
  }
  
  result
}

#' Get PIX Transactions by Region
#'
#' @description
#' A convenience wrapper that aggregates municipality data at the region level.
#'
#' @inheritParams get_pix_transactions_by_municipality
#'
#' @return A [tibble::tibble] with PIX transaction data aggregated by region.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get region-level aggregates
#' regions <- get_pix_transactions_by_region(database = "202512")
#' }
get_pix_transactions_by_region <- function(database, verbose = TRUE) {
  
  if (verbose) {
    cli::cli_h2("Fetching PIX Transactions by Region")
  }
  
  data <- get_pix_transactions_by_municipality(
    database = database,
    verbose = verbose
  )
  
  if (nrow(data) == 0) {
    return(data)
  }
  
  # Aggregate by region
  result <- data |>
    dplyr::group_by(.data$AnoMes, .data$Sigla_Regiao, .data$Regiao) |>
    dplyr::summarise(
      n_states = dplyr::n_distinct(.data$Estado_Ibge),
      n_municipalities = dplyr::n(),
      vl_pagador_pf = sum(.data$VL_PagadorPF, na.rm = TRUE),
      qt_pagador_pf = sum(.data$QT_PagadorPF, na.rm = TRUE),
      vl_pagador_pj = sum(.data$VL_PagadorPJ, na.rm = TRUE),
      qt_pagador_pj = sum(.data$QT_PagadorPJ, na.rm = TRUE),
      vl_recebedor_pf = sum(.data$VL_RecebedorPF, na.rm = TRUE),
      qt_recebedor_pf = sum(.data$QT_RecebedorPF, na.rm = TRUE),
      vl_recebedor_pj = sum(.data$VL_RecebedorPJ, na.rm = TRUE),
      qt_recebedor_pj = sum(.data$QT_RecebedorPJ, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$vl_pagador_pf))
  
  if (verbose) {
    cli::cli_alert_success("Aggregated data for {nrow(result)} region{?s}")
  }
  
  result
}
