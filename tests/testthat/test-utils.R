test_that("format_brl formats Brazilian currency", {
  expect_equal(format_brl(1234567.89), "R$ 1.234.567,89")
  expect_equal(format_brl(1000, prefix = FALSE), "1.000,00")
  expect_equal(format_brl(0.5), "R$ 0,50")
})

test_that("format_brl is vectorized", {
  res <- format_brl(c(1000, 2000))
  expect_length(res, 2)
  expect_match(res, "^R\\$ ")
})

test_that("pix_endpoints returns the endpoint catalog", {
  ep <- pix_endpoints()
  expect_s3_class(ep, "tbl_df")
  expect_equal(nrow(ep), 6)
  expect_setequal(
    ep$endpoint,
    c("ChavesPix", "TransacoesPixPorMunicipio",
      "EstatisticasTransacoesPix", "EstatisticasFraudesPix",
      "CnaePorteRecebedor", "PixUsuariosCadastradosDICT")
  )
})

test_that("pix_columns returns column metadata for each endpoint", {
  for (ep in c("keys", "municipality", "stats", "fraud", "cnae", "dict_users")) {
    cols <- pix_columns(ep)
    expect_s3_class(cols, "tbl_df")
    expect_true(all(c("column", "type", "description") %in% names(cols)))
  }
  expect_error(pix_columns("nonexistent"))
})

test_that("pix_timeout gets and sets the timeout option", {
  withr::local_options(pixr.timeout = NULL)
  expect_equal(pix_timeout(), 120)
  expect_message(res <- pix_timeout(180), "180")
  expect_equal(res, 180)
  expect_equal(pix_timeout(), 180)
  expect_equal(getOption("pixr.timeout"), 180L)
})

test_that("pix_timeout rejects invalid values", {
  expect_error(pix_timeout(-1), "Invalid timeout")
  expect_error(pix_timeout("abc"), "Invalid timeout")
  expect_error(pix_timeout(c(1, 2)), "Invalid timeout")
})
