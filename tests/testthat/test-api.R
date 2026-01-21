# Integration tests - these require network access
# Skip if offline or API is unavailable

skip_if_offline <- function() {
  tryCatch({
    con <- url("https://olinda.bcb.gov.br", "r")
    close(con)
    TRUE
  }, error = function(e) {
    skip("API not reachable")
  })
}

test_that("get_pix_keys returns tibble", {
  skip_if_offline()
  skip_on_cran()
  
  result <- get_pix_keys(top = 5, verbose = FALSE)
  
  expect_s3_class(result, "tbl_df")
  expect_lte(nrow(result), 5)
  expect_true("Participante" %in% names(result))
})

test_that("get_pix_keys filters by year_month", {
  skip_if_offline()
  skip_on_cran()
  
  result <- get_pix_keys(year_month = "202312", top = 5, verbose = FALSE)
  
  expect_s3_class(result, "tbl_df")
  if (nrow(result) > 0 && "AnoMes" %in% names(result)) {
    expect_true(all(result$AnoMes == "202312"))
  }
})

test_that("get_pix_transaction_stats returns tibble", {
  skip_if_offline()
  skip_on_cran()
  
  result <- get_pix_transaction_stats(top = 5, verbose = FALSE)
  
  expect_s3_class(result, "tbl_df")
  expect_lte(nrow(result), 5)
})

test_that("get_pix_transaction_stats filters by date range", {
  skip_if_offline()
  skip_on_cran()
  
  result <- get_pix_transaction_stats(
    start_date = "202301",
    end_date = "202312",
    verbose = FALSE
  )
  
  expect_s3_class(result, "tbl_df")
  if (nrow(result) > 0 && "AnoMes" %in% names(result)) {
    expect_true(all(result$AnoMes >= "202301"))
    expect_true(all(result$AnoMes <= "202312"))
  }
})

test_that("get_pix_transactions_by_municipality returns tibble", {
  skip_if_offline()
  skip_on_cran()
  
  result <- get_pix_transactions_by_municipality(top = 5, verbose = FALSE)
  
  expect_s3_class(result, "tbl_df")
  expect_lte(nrow(result), 5)
})

test_that("get_pix_transactions_by_municipality filters by state", {
  skip_if_offline()
  skip_on_cran()
  
  result <- get_pix_transactions_by_municipality(
    state_code = "SP",
    top = 5,
    verbose = FALSE
  )
  
  expect_s3_class(result, "tbl_df")
  if (nrow(result) > 0 && "UF" %in% names(result)) {
    expect_true(all(result$UF == "SP"))
  }
})

test_that("pix_query works with custom parameters", {
  skip_if_offline()
  skip_on_cran()
  
  result <- pix_query(
    endpoint = "ChavesPix",
    top = 3,
    verbose = FALSE
  )
  
  expect_s3_class(result, "tbl_df")
  expect_lte(nrow(result), 3)
})
