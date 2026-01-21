test_that("parse_year_month validates format", {
  expect_equal(parse_year_month("202312"), "202312")
  expect_equal(parse_year_month("202001"), "202001")
  expect_null(parse_year_month(NULL))
  
  # Invalid formats
  expect_error(parse_year_month("2023-12"), "Invalid year_month format")
  expect_error(parse_year_month("12/2023"), "Invalid year_month format")
  expect_error(parse_year_month("20231"), "Invalid year_month format")
  expect_error(parse_year_month("2023123"), "Invalid year_month format")
})

test_that("parse_year_month handles Date objects", {
  date <- as.Date("2023-12-15")
  result <- parse_year_month(date)
  expect_equal(result, "202312")
})

test_that("validate_columns returns NULL for NULL input", {
  expect_null(validate_columns(NULL, c("A", "B", "C")))
})

test_that("validate_columns filters invalid columns", {
  valid <- c("A", "B", "C")
  
  # All valid
  expect_equal(validate_columns(c("A", "B"), valid), c("A", "B"))
  
  # Some invalid - expect warning
  expect_warning(
    result <- validate_columns(c("A", "X", "Y"), valid),
    "Unknown column"
  )
  expect_equal(result, "A")
})

test_that("validate_columns returns NULL when all columns invalid", {
  expect_warning(
    result <- validate_columns(c("X", "Y"), c("A", "B", "C")),
    "Unknown column"
  )
  expect_null(result)
})

test_that("build_filter creates correct expressions", {
  # Single condition
  expect_equal(
    build_filter(year = 2023),
    "year eq 2023"
  )
  
  # String value
  expect_equal(
    build_filter(name = "test"),
    "name eq 'test'"
  )
  
  # Multiple conditions
  result <- build_filter(year = 2023, name = "test")
  expect_true(grepl("year eq 2023", result))
  expect_true(grepl("name eq 'test'", result))
  expect_true(grepl(" and ", result))
})

test_that("build_filter returns NULL for empty input", {
  expect_null(build_filter())
})

test_that("build_filter handles NULL values", {
  expect_equal(
    build_filter(a = 1, b = NULL, c = 3),
    "a eq 1 and c eq 3"
  )
})

test_that("pix_request creates valid httr2 request", {
  req <- pix_request("ChavesPix")
  
  expect_s3_class(req, "httr2_request")
  expect_true(grepl("Pix_DadosAbertos", req$url))
  expect_true(grepl("ChavesPix", req$url))
})

test_that("pix_request adds query parameters", {
  req <- pix_request(
    endpoint = "ChavesPix",
    filter = "AnoMes eq '202312'",
    select = c("A", "B"),
    orderby = "A asc",
    top = 10,
    skip = 5
  )
  
  # Check URL contains parameters
  url <- req$url
  expect_true(grepl("\\$filter=", url))
  expect_true(grepl("\\$select=", url))
  expect_true(grepl("\\$orderby=", url))
  expect_true(grepl("\\$top=", url))
  expect_true(grepl("\\$skip=", url))
})
