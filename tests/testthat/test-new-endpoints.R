test_that("get_pix_cnae_stats requires database", {
  expect_error(get_pix_cnae_stats(), "database")
  expect_error(get_pix_cnae_stats(database = "2025"), "Invalid year_month")
})

test_that("CnaePorteRecebedor URL is built correctly", {
  url <- pix_url(
    "CnaePorteRecebedor",
    params = list(Database = "202506"),
    filter = "mei eq 'S'",
    top = 5
  )
  expect_match(url, "CnaePorteRecebedor(Database=@Database)", fixed = TRUE)
  expect_match(url, "@Database='202506'", fixed = TRUE)
  expect_match(url, "$filter=mei%20eq%20'S'", fixed = TRUE)
})

test_that("PixUsuariosCadastradosDICT URL is built without parameters", {
  url <- pix_url(
    "PixUsuariosCadastradosDICT",
    orderby = "DataGraficosPix desc",
    top = 12
  )
  expect_match(url, "odata/PixUsuariosCadastradosDICT?", fixed = TRUE)
  expect_match(url, "$orderby=DataGraficosPix%20desc", fixed = TRUE)
  expect_false(grepl("@", url, fixed = TRUE))
})

test_that("pix_endpoints includes the new endpoints", {
  ep <- pix_endpoints()
  expect_equal(nrow(ep), 6)
  expect_true(all(
    c("CnaePorteRecebedor", "PixUsuariosCadastradosDICT") %in% ep$endpoint
  ))
})

test_that("pix_columns covers cnae, dict_users, and the full fraud schema", {
  expect_equal(nrow(pix_columns("cnae")), 15)
  expect_equal(nrow(pix_columns("dict_users")), 4)
  fraud <- pix_columns("fraud")
  expect_equal(nrow(fraud), 24)
  expect_true("QtdePixcontestados" %in% fraud$column)
})

test_that("clean_dict_users_data parses dates and counts", {
  raw <- tibble::tibble(
    DataGraficosPix = "2026-09-30",
    qtdUsuariosPessoaFisica = "168245596",
    qtdUsuariosPessoaJuridica = "18729138",
    qtdUsuariosCadastradosDICTTotal = "186974734"
  )
  res <- pixr:::clean_dict_users_data(raw)
  expect_s3_class(res$DataGraficosPix, "Date")
  expect_type(res$qtdUsuariosPessoaFisica, "double")
})

test_that("clean_cnae_data converts numeric columns", {
  raw <- tibble::tibble(
    AnoMes = "202506", porte = "Microempresa",
    qtlanliq = "12306", vllanliq = "34603287.12"
  )
  res <- pixr:::clean_cnae_data(raw)
  expect_type(res$AnoMes, "double")
  expect_type(res$vllanliq, "double")
  expect_type(res$porte, "character")
})
