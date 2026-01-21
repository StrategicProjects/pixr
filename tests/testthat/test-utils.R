test_that("year_month_to_date converts correctly", {
  expect_equal(year_month_to_date("202312"), as.Date("2023-12-01"))
  expect_equal(year_month_to_date("202301"), as.Date("2023-01-01"))
  
  # Vector input
  result <- year_month_to_date(c("202301", "202302", "202303"))
  expected <- as.Date(c("2023-01-01", "2023-02-01", "2023-03-01"))
  expect_equal(result, expected)
})

test_that("year_month_to_date handles NULL", {
  expect_null(year_month_to_date(NULL))
})

test_that("year_month_to_date validates format", {
  expect_error(year_month_to_date("2023-12"), "Invalid year_month format")
  expect_error(year_month_to_date("12/2023"), "Invalid year_month format")
  expect_error(year_month_to_date("abc"), "Invalid year_month format")
})

test_that("format_brl formats correctly", {
  expect_equal(format_brl(1234.56), "R$ 1.234,56")
  expect_equal(format_brl(1000000), "R$ 1.000.000,00")
  expect_equal(format_brl(0), "R$ 0,00")
})

test_that("format_brl handles prefix option", {
  expect_equal(format_brl(1234.56, prefix = FALSE), "1.234,56")
})

test_that("pix_endpoints returns tibble", {
  result <- pix_endpoints()
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
  expect_true("endpoint" %in% names(result))
  expect_true("function_name" %in% names(result))
  expect_true("description" %in% names(result))
})

test_that("pix_columns returns tibble for all endpoints", {
  for (ep in c("keys", "municipality", "stats")) {
    result <- pix_columns(ep)
    expect_s3_class(result, "tbl_df")
    expect_true(nrow(result) > 0)
    expect_true(all(c("column", "type", "description") %in% names(result)))
  }
})

test_that("pix_columns validates endpoint argument", {
  expect_error(pix_columns("invalid"), "should be one of")
})
