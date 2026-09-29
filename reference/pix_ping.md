# Check API Connection

Tests the connection to all BCB PIX Open Data API endpoints. Each
endpoint is tested with a single record request (top=1).

## Usage

``` r
pix_ping()
```

## Value

A tibble (invisibly) with columns:

- endpoint:

  Name of the endpoint tested

- status:

  Result: "OK" or error message

- time_seconds:

  Time taken for the request in seconds

## Examples

``` r
if (FALSE) # It usually takes much longer than 5 seconds.
# Test all endpoints
pix_ping()

# Capture results
results <- pix_ping()
#> 
#> ── Testing BCB PIX API Endpoints ──
#> 
#> ℹ Testing ChavesPix...
#> ✔ ChavesPix: "OK" (11.48s)
#> ℹ Testing TransacoesPixPorMunicipio...
#> ✔ TransacoesPixPorMunicipio: "OK" (13.46s)
#> ℹ Testing EstatisticasTransacoesPix...
#> ✔ EstatisticasTransacoesPix: "OK" (0.2s)
#> ℹ Testing EstatisticasFraudesPix...
#> ✖ EstatisticasFraudesPix: Failed to perform HTTP request. Caused by error in `curl::curl_fetch_memory()`: ! Timeout was reached [olinda.bcb.gov.br]: Operation timed out after 120002 milliseconds with 0 bytes received (120.01s)
#> ────────────────────────────────────────────────────────────────────────────────
#> ℹ Total time: 145.17s
#> ℹ Success: 3/4 endpoints
print(results)
#> # A tibble: 4 × 3
#>   endpoint                  status                                  time_seconds
#>   <chr>                     <chr>                                          <dbl>
#> 1 ChavesPix                 "OK"                                          11.5  
#> 2 TransacoesPixPorMunicipio "OK"                                          13.5  
#> 3 EstatisticasTransacoesPix "OK"                                           0.204
#> 4 EstatisticasFraudesPix    "Failed to perform HTTP request.\n\u00…      120.   
 # \dontrun{}
```
