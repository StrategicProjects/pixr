#' @title BCB PIX API Client Utilities
#' @description Internal functions for making requests to the BCB PIX Open Data API
#' @name client
#' @keywords internal
NULL

#' Base URL for the BCB PIX Open Data API
#' @noRd
PIX_BASE_URL <- "https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata"
#' Default timeout in seconds
#' @noRd
PIX_DEFAULT_TIMEOUT <- 120

#' Get the configured timeout
#'
#' @description
#' Returns the timeout value from options, or the default if not set.
#' Users can configure timeout via `options(pixr.timeout = seconds)`.
#'
#' @return Integer timeout in seconds
#' @noRd
get_timeout <- function() {
 getOption("pixr.timeout", default = PIX_DEFAULT_TIMEOUT)
}

#' Create a new API request
#'
#' @description
#' Creates an httr2 request for the BCB PIX API. The BCB API uses a special
#' OData syntax where parameters are passed as function arguments in the URL.
#'
#' @param endpoint Character string specifying the API endpoint
#' @param params Named list of endpoint parameters (e.g., list(Database = "202312"))
#' @param format Response format: "json", "xml", "csv", or "html"
#' @param filter OData filter expression
#' @param select Character vector of columns to select
#' @param orderby Column to order by (already formatted as "Column asc" or "Column desc")
#' @param top Maximum number of records to return
#' @param skip Number of records to skip (not supported by the BCB PIX API)
#'
#' @return An httr2 request object
#' @noRd
pix_request <- function(endpoint,
                        params = NULL,
                        format = "json",
                        filter = NULL,
                        select = NULL,
                        orderby = NULL,
                        top = NULL,
                        skip = NULL) {
  
  # Build the endpoint URL with function parameters
  # BCB uses syntax like: Endpoint(Param1=@Param1)?@Param1='value'
  if (!is.null(params) && length(params) > 0) {
    param_names <- names(params)
    func_params <- paste0(param_names, "=@", param_names, collapse = ",")
    endpoint_url <- paste0(PIX_BASE_URL, "/", endpoint, "(", func_params, ")")
  } else {
    endpoint_url <- paste0(PIX_BASE_URL, "/", endpoint)
  }
  
  # Build query string manually to avoid encoding OData parameters
  query_parts <- list()
  
  # Add format
  query_parts <- c(query_parts, paste0("$format=", format))
  
  # Add endpoint parameters as @Param='value'
  if (!is.null(params) && length(params) > 0) {
    for (param_name in names(params)) {
      param_value <- params[[param_name]]
      if (is.character(param_value)) {
        query_parts <- c(query_parts, paste0("@", param_name, "='", param_value, "'"))
      } else {
        query_parts <- c(query_parts, paste0("@", param_name, "=", param_value))
      }
    }
  }
  
  # Add optional OData query parameters (NOT encoded)
  if (!is.null(filter) && nzchar(filter)) {
    query_parts <- c(query_parts, paste0("$filter=", filter))
  }
  
  if (!is.null(select) && length(select) > 0) {
    query_parts <- c(query_parts, paste0("$select=", paste(select, collapse = ",")))
  }
  
  if (!is.null(orderby) && nzchar(orderby)) {
    query_parts <- c(query_parts, paste0("$orderby=", orderby))
  }
  
  if (!is.null(top)) {
    query_parts <- c(query_parts, paste0("$top=", as.integer(top)))
  }
  
  # if (!is.null(skip)) {
  #   query_parts <- c(query_parts, paste0("$skip=", as.integer(skip)))
  # }
  if (!is.null(skip)) {
    cli::cli_warn(c(
      "Parameter {.arg skip} is not supported by the BCB PIX API",
      "i" = "Pagination with skip is not currently available",
      "i" = "Use {.arg top} to limit results instead"
    ))
    # Não adiciona à query - API não suporta
  }
  
  # Build full URL - encode only spaces as %20
  query_string <- paste(query_parts, collapse = "&")
  query_string <- gsub(" ", "%20", query_string)
  full_url <- paste0(endpoint_url, "?", query_string)
  
  # Get timeout
  timeout_seconds <- get_timeout()
  
  # Create request without additional encoding
  req <- httr2::request(full_url) |>
    httr2::req_headers(
      Accept = "application/json;odata.metadata=minimal"
    ) |>
    httr2::req_user_agent("pixr R package (https://github.com/yourname/pixr)") |>
    httr2::req_timeout(timeout_seconds) |>
    httr2::req_retry(max_tries = 3, backoff = ~ 2)
  
  req
}

#' Perform an API request and parse the response
#'
#' @param req An httr2 request object
#' @param verbose Logical; if TRUE, print progress messages
#'
#' @return A tibble with the response data
#' @noRd
pix_perform <- function(req, verbose = TRUE) {
  
  if (verbose) {
    cli::cli_progress_step("Fetching data from BCB PIX API...")
    cli::cli_alert_info("URL: {req$url}")
  }
  
  resp <- tryCatch({
    httr2::req_perform(req)
  }, error = function(e) {
    cli::cli_abort(c(
      "Connection error to BCB PIX API",
      "x" = conditionMessage(e),
      "i" = "Check your internet connection",
      "i" = "The BCB API might be temporarily unavailable",
      "i" = "URL: {req$url}"
    ))
  })
  
  if (verbose) {
    cli::cli_progress_step("Parsing response...")
  }
  
  # Check response status
  status_code <- httr2::resp_status(resp)
  if (status_code != 200) {
    body_text <- tryCatch(
      httr2::resp_body_string(resp),
      error = function(e) "Unable to read response body"
    )
    
    cli::cli_abort(c(
      "API request failed with status {status_code}",
      "x" = httr2::resp_status_desc(resp),
      "i" = "URL: {httr2::resp_url(resp)}",
      "i" = "Response: {substr(body_text, 1, 500)}"
    ))
  }
  
  # Parse JSON response
  body <- tryCatch({
    httr2::resp_body_json(resp, simplifyVector = TRUE)
  }, error = function(e) {
    body_text <- httr2::resp_body_string(resp)
    cli::cli_abort(c(
      "Failed to parse JSON response",
      "x" = conditionMessage(e),
      "i" = "Raw response: {substr(body_text, 1, 500)}"
    ))
  })
  
  # OData responses have a 'value' field containing the data
  if ("value" %in% names(body)) {
    data <- body$value
  } else {
    data <- body
  }
  
  # Handle empty response
  if (is.null(data) || length(data) == 0) {
    if (verbose) {
      cli::cli_alert_warning("No data returned from API")
    }
    return(tibble::tibble())
  }
  
  # Convert to tibble
  result <- tibble::as_tibble(data)
  
  if (verbose) {
    cli::cli_alert_success("Retrieved {nrow(result)} record{?s}")
  }
  
  result
}

#' Parse year-month string to the format expected by BCB API
#'
#' @param year_month Character string in format "YYYYMM" or numeric
#'
#' @return Character string in YYYYMM format
#' @noRd
parse_year_month <- function(year_month) {
  if (is.null(year_month)) {
    return(NULL)
  }
  
  if (inherits(year_month, "Date")) {
    return(format(year_month, "%Y%m"))
  }
  
  # Convert numeric to character
  year_month <- as.character(year_month)
  
  # Validate format
  if (!grepl("^\\d{6}$", year_month)) {
    cli::cli_abort(c(
      "Invalid year_month format",
      "x" = "Got: {year_month}",
      "i" = "Expected format: YYYYMM (e.g., '202312' for December 2023)"
    ))
  }
  
  year_month
}

#' Validate and prepare columns for select
#'
#' @param columns Character vector of column names
#' @param valid_columns Character vector of valid column names
#'
#' @return Character vector of validated column names
#' @noRd
validate_columns <- function(columns, valid_columns) {
  if (is.null(columns)) {
    return(NULL)
  }
  
  invalid <- setdiff(columns, valid_columns)
  
  if (length(invalid) > 0) {
    cli::cli_warn(c(
      "Unknown column{?s} will be ignored",
      "x" = "Invalid: {.val {invalid}}",
      "i" = "Valid columns: {.val {valid_columns}}"
    ))
    columns <- intersect(columns, valid_columns)
  }
  
  if (length(columns) == 0) {
    return(NULL)
  }
  
  columns
}

#' Format orderby parameter
#'
#' @param orderby Column name, optionally with "-" prefix for descending
#' @param valid_columns Vector of valid column names
#'
#' @return Formatted orderby string or NULL
#' @noRd
format_orderby <- function(orderby, valid_columns = NULL) {
  if (is.null(orderby) || !nzchar(orderby)) {
    return(NULL)
  }
  
  # Check for descending prefix
  if (startsWith(orderby, "-")) {
    col <- substring(orderby, 2)
    direction <- "desc"
  } else {
    col <- orderby
    direction <- "asc"
  }
  
  # Validate column if valid_columns provided
  if (!is.null(valid_columns) && !col %in% valid_columns) {
    cli::cli_warn(c(
      "Invalid orderby column",
      "x" = "Column '{col}' not found",
      "i" = "Valid columns: {.val {valid_columns}}",
      "!" = "orderby will be ignored"
    ))
    return(NULL)
  }
  
  paste(col, direction)
}
