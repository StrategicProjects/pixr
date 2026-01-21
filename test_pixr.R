# =============================================================================
# pixr Package Test Script
# =============================================================================
# Run this script to test the package functions and diagnose API issues
#
# Usage:
#   1. Install the package: devtools::load_all("pixr")
#   2. Run this script: source("test_pixr.R")
#
# =============================================================================

library(pixr)

cat("\n")
cli::cli_h1("pixr Package Test Suite")
cat("\n")

# =============================================================================
# Test Parameters
# =============================================================================

# ChavesPix uses Data in YYYY-MM-DD format
test_date <- "2025-12-01"

# Other endpoints use YYYYMM format
test_database <- "202512"

cli::cli_alert_info("Test date for ChavesPix: {test_date}")
cli::cli_alert_info("Test database for other endpoints: {test_database}")

# -----------------------------------------------------------------------------
# Test 0: Show expected URL formats
# -----------------------------------------------------------------------------
cli::cli_h2("Test 0: URL Format Check")

cat("\n1. ChavesPix (uses Data=YYYY-MM-DD):\n")
cat(URLdecode(pix_url("ChavesPix", params = list(Data = test_date), top = 5)), "\n\n")

cat("2. EstatisticasTransacoesPix (uses Database=YYYYMM):\n")
cat(URLdecode(pix_url("EstatisticasTransacoesPix", params = list(Database = test_database), top = 5)), "\n\n")

cat("3. TransacoesPixPorMunicipio (uses DataBase=YYYYMM):\n")
cat(URLdecode(pix_url("TransacoesPixPorMunicipio", params = list(DataBase = test_database), top = 5)), "\n\n")

cat("4. TransacoesPixPorMunicipio with filter and orderby:\n")
cat(URLdecode(pix_url(
  "TransacoesPixPorMunicipio",
  params = list(DataBase = test_database),
  filter = "Estado eq 'MARANHÃO'",
  orderby = "Municipio desc",
  top = 10
)), "\n\n")

cat("5. EstatisticasFraudesPix (uses Database=YYYYMM):\n")
cat(URLdecode(pix_url("EstatisticasFraudesPix", params = list(Database = test_database), top = 5)), "\n\n")

# -----------------------------------------------------------------------------
# Test 1: PIX Keys (ChavesPix)
# -----------------------------------------------------------------------------
cli::cli_h2("Test 1: PIX Keys (ChavesPix)")
cli::cli_alert_info("Using date = '{test_date}'")

tryCatch({
  keys <- get_pix_keys(date = test_date, top = 10)
  cli::cli_alert_success("Retrieved {nrow(keys)} records")
  print(keys)
}, error = function(e) {
  cli::cli_alert_danger("Failed: {conditionMessage(e)}")
})

# -----------------------------------------------------------------------------
# Test 2: Transaction Statistics (EstatisticasTransacoesPix)
# -----------------------------------------------------------------------------
cli::cli_h2("Test 2: Transaction Statistics")
cli::cli_alert_info("Using database = '{test_database}'")

tryCatch({
  stats <- get_pix_transaction_stats(database = test_database, top = 10)
  cli::cli_alert_success("Retrieved {nrow(stats)} records")
  print(stats)
}, error = function(e) {
  cli::cli_alert_danger("Failed: {conditionMessage(e)}")
})

# -----------------------------------------------------------------------------
# Test 3: Transactions by Municipality (TransacoesPixPorMunicipio)
# -----------------------------------------------------------------------------
cli::cli_h2("Test 3: Transactions by Municipality")
cli::cli_alert_info("Using database = '{test_database}'")

tryCatch({
  muni <- get_pix_transactions_by_municipality(database = test_database, top = 10)
  cli::cli_alert_success("Retrieved {nrow(muni)} records")
  print(muni)
}, error = function(e) {
  cli::cli_alert_danger("Failed: {conditionMessage(e)}")
})

# -----------------------------------------------------------------------------
# Test 3b: Transactions with Filter and OrderBy
# -----------------------------------------------------------------------------
cli::cli_h2("Test 3b: Filter and OrderBy")
cli::cli_alert_info("Filter: Estado eq 'MARANHÃO', OrderBy: Municipio desc")

tryCatch({
  muni_filtered <- get_pix_transactions_by_municipality(
    database = test_database,
    filter = "Estado eq 'MARANHÃO'",
    orderby = "Municipio desc",
    top = 10
  )
  cli::cli_alert_success("Retrieved {nrow(muni_filtered)} records")
  print(muni_filtered)
}, error = function(e) {
  cli::cli_alert_danger("Failed: {conditionMessage(e)}")
})

# -----------------------------------------------------------------------------
# Test 4: Fraud Statistics (EstatisticasFraudesPix)
# -----------------------------------------------------------------------------
cli::cli_h2("Test 4: Fraud Statistics (MED)")
cli::cli_alert_info("Using database = '{test_database}'")

tryCatch({
  fraud <- get_pix_fraud_stats(database = test_database, top = 10)
  cli::cli_alert_success("Retrieved {nrow(fraud)} records")
  print(fraud)
}, error = function(e) {
  cli::cli_alert_danger("Failed: {conditionMessage(e)}")
})

# -----------------------------------------------------------------------------
# Test 5: Summary Functions
# -----------------------------------------------------------------------------
cli::cli_h2("Test 5: Summary by Transaction Nature")

tryCatch({
  summary <- get_pix_summary(database = test_database, group_by = "NATUREZA")
  cli::cli_alert_success("Retrieved {nrow(summary)} groups")
  print(summary)
}, error = function(e) {
  cli::cli_alert_danger("Failed: {conditionMessage(e)}")
})

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------
cli::cli_h2("API Parameter Reference")

cli::cli_bullets(c(
  " " = "ChavesPix: Data = 'YYYY-MM-DD' (e.g., '2025-12-01')",
  " " = "TransacoesPixPorMunicipio: DataBase = 'YYYYMM' (e.g., '202512')",
  " " = "EstatisticasTransacoesPix: Database = 'YYYYMM' (e.g., '202512')",
  " " = "EstatisticasFraudesPix: Database = 'YYYYMM' (e.g., '202512')"
))

cli::cli_h2("OData Filter Examples")
cli::cli_bullets(c(
  " " = "filter = \"Estado eq 'MARANHÃO'\"",
  " " = "filter = \"NATUREZA eq 'P2P'\"",
  " " = "filter = \"TipoChave eq 'CPF'\"",
  " " = "filter = \"VALOR gt 1000\"",
  " " = "filter = \"PAG_REGIAO eq 'SUDESTE' and NATUREZA eq 'P2P'\""
))

cli::cli_h2("OData OrderBy Examples")
cli::cli_bullets(c(
  " " = "orderby = \"Municipio\" (ascending)",
  " " = "orderby = \"Municipio desc\" (descending)",
  " " = "orderby = \"qtdChaves desc\"",
  " " = "orderby = \"VALOR desc\""
))

cat("\n")
cli::cli_alert_success("Test script completed!")
cat("\n")



