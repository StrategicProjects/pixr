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
#> ✔ ChavesPix: "OK" (4.21s)
#> ℹ Testing TransacoesPixPorMunicipio...
#> ✔ TransacoesPixPorMunicipio: "OK" (0.16s)
#> ℹ Testing EstatisticasTransacoesPix...
#> ✔ EstatisticasTransacoesPix: "OK" (0.15s)
#> ℹ Testing EstatisticasFraudesPix...
#> ✔ EstatisticasFraudesPix: "OK" (0.15s)
#> ────────────────────────────────────────────────────────────────────────────────
#> ℹ Total time: 4.67s
#> ℹ Success: 4/4 endpoints
print(results)
#> # A tibble: 4 × 3
#>   endpoint                  status time_seconds
#>   <chr>                     <chr>         <dbl>
#> 1 ChavesPix                 OK            4.21 
#> 2 TransacoesPixPorMunicipio OK            0.158
#> 3 EstatisticasTransacoesPix OK            0.145
#> 4 EstatisticasFraudesPix    OK            0.150
 # \dontrun{}
```
