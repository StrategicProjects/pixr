test_that("parse_year_month accepts valid inputs", {
  expect_equal(pixr:::parse_year_month("202312"), "202312")
  expect_equal(pixr:::parse_year_month(202312), "202312")
  expect_equal(pixr:::parse_year_month(as.Date("2023-12-15")), "202312")
  expect_null(pixr:::parse_year_month(NULL))
})

test_that("parse_year_month rejects invalid formats", {
  expect_error(pixr:::parse_year_month("2023-12"), "Invalid year_month")
  expect_error(pixr:::parse_year_month("23"), "Invalid year_month")
  expect_error(pixr:::parse_year_month("abc123"), "Invalid year_month")
})

test_that("parse_date_param accepts valid inputs", {
  expect_equal(pixr:::parse_date_param("2025-12-01"), "2025-12-01")
  expect_equal(pixr:::parse_date_param(as.Date("2025-12-01")), "2025-12-01")
  expect_null(pixr:::parse_date_param(NULL))
})

test_that("parse_date_param rejects invalid formats", {
  expect_error(pixr:::parse_date_param("202512"), "Invalid date")
  expect_error(pixr:::parse_date_param("01/12/2025"), "Invalid date")
})

test_that("year_month_to_date converts correctly", {
  expect_equal(year_month_to_date("202312"), as.Date("2023-12-01"))
  expect_equal(
    year_month_to_date(c("202301", "202302")),
    as.Date(c("2023-01-01", "2023-02-01"))
  )
  expect_null(year_month_to_date(NULL))
  expect_error(year_month_to_date("2023"), "Invalid year_month")
})

test_that("validate_columns keeps valid and drops invalid columns", {
  valid <- c("A", "B", "C")
  expect_equal(pixr:::validate_columns(c("A", "B"), valid), c("A", "B"))
  expect_null(pixr:::validate_columns(NULL, valid))
  expect_warning(
    res <- pixr:::validate_columns(c("A", "X"), valid),
    "unknown column"
  )
  expect_equal(res, "A")
  expect_warning(
    res <- pixr:::validate_columns("X", valid),
    "unknown column"
  )
  expect_null(res)
})
