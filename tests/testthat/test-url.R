test_that("pix_url builds parameterized endpoint URLs", {
  url <- pix_url("ChavesPix", params = list(Data = "2025-12-01"), top = 10)
  expect_match(url, "ChavesPix\\(Data=@Data\\)", fixed = FALSE)
  expect_match(url, "@Data='2025-12-01'", fixed = TRUE)
  expect_match(url, "$top=10", fixed = TRUE)
  expect_match(url, "$format=json", fixed = TRUE)
})

test_that("pix_url builds plain endpoint URLs without params", {
  url <- pix_url("ChavesPix")
  expect_match(url, "odata/ChavesPix\\?")
  expect_false(grepl("@", url, fixed = TRUE))
})

test_that("pix_url encodes spaces in OData expressions", {
  url <- pix_url(
    "EstatisticasTransacoesPix",
    params = list(Database = "202509"),
    filter = "NATUREZA eq 'P2P'"
  )
  expect_match(url, "$filter=NATUREZA%20eq%20'P2P'", fixed = TRUE)
  expect_false(grepl(" ", url, fixed = TRUE))
})

test_that("pix_url passes select and orderby through", {
  url <- pix_url(
    "TransacoesPixPorMunicipio",
    params = list(DataBase = "202512"),
    select = c("Municipio", "Estado"),
    orderby = "Municipio desc"
  )
  expect_match(url, "$select=Municipio,Estado", fixed = TRUE)
  expect_match(url, "$orderby=Municipio%20desc", fixed = TRUE)
})

test_that("numeric endpoint parameters are not quoted", {
  url <- pix_url("ChavesPix", params = list(Numero = 10))
  expect_match(url, "@Numero=10", fixed = TRUE)
  expect_false(grepl("@Numero='10'", url, fixed = TRUE))
})

test_that("invalid top values abort", {
  expect_error(pix_url("ChavesPix", top = "abc"), "Invalid")
  expect_error(pix_url("ChavesPix", top = 0), "Invalid")
  expect_error(pix_url("ChavesPix", top = -5), "Invalid")
})

test_that("skip warns and is not added to the query", {
  expect_warning(
    url <- pix_url("ChavesPix", skip = 10),
    "not supported"
  )
  expect_false(grepl("skip", url, fixed = TRUE))
})
