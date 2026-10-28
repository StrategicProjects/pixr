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
#> ✔ ChavesPix: "OK" (1.8s)
#> ℹ Testing TransacoesPixPorMunicipio...
#> ✔ TransacoesPixPorMunicipio: "OK" (1.9s)
#> ℹ Testing EstatisticasTransacoesPix...
#> ✔ EstatisticasTransacoesPix: "OK" (17.61s)
#> ℹ Testing EstatisticasFraudesPix...
#> ✔ EstatisticasFraudesPix: "OK" (0.26s)
#> ℹ Testing CnaePorteRecebedor...
#> ✔ CnaePorteRecebedor: "OK" (0.21s)
#> ℹ Testing PixUsuariosCadastradosDICT...
#> ✔ PixUsuariosCadastradosDICT: "OK" (0.25s)
#> ────────────────────────────────────────────────────────────────────────────────
#> ℹ Total time: 22.03s
#> ℹ Success: 6/6 endpoints
print(results)
#> # A tibble: 6 × 3
#>   endpoint                   status time_seconds
#>   <chr>                      <chr>         <dbl>
#> 1 ChavesPix                  OK            1.80 
#> 2 TransacoesPixPorMunicipio  OK            1.90 
#> 3 EstatisticasTransacoesPix  OK           17.6  
#> 4 EstatisticasFraudesPix     OK            0.261
#> 5 CnaePorteRecebedor         OK            0.210
#> 6 PixUsuariosCadastradosDICT OK            0.247
 # \dontrun{}
```
