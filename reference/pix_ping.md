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
#> ✔ ChavesPix: "OK" (0.2s)
#> ℹ Testing TransacoesPixPorMunicipio...
#> ✔ TransacoesPixPorMunicipio: "OK" (0.2s)
#> ℹ Testing EstatisticasTransacoesPix...
#> ✔ EstatisticasTransacoesPix: "OK" (0.2s)
#> ℹ Testing EstatisticasFraudesPix...
#> ✔ EstatisticasFraudesPix: "OK" (0.29s)
#> ℹ Testing CnaePorteRecebedor...
#> ✔ CnaePorteRecebedor: "OK" (2.86s)
#> ℹ Testing PixUsuariosCadastradosDICT...
#> ✔ PixUsuariosCadastradosDICT: "OK" (1.72s)
#> ────────────────────────────────────────────────────────────────────────────────
#> ℹ Total time: 5.47s
#> ℹ Success: 6/6 endpoints
print(results)
#> # A tibble: 6 × 3
#>   endpoint                   status time_seconds
#>   <chr>                      <chr>         <dbl>
#> 1 ChavesPix                  OK            0.203
#> 2 TransacoesPixPorMunicipio  OK            0.202
#> 3 EstatisticasTransacoesPix  OK            0.204
#> 4 EstatisticasFraudesPix     OK            0.286
#> 5 CnaePorteRecebedor         OK            2.86 
#> 6 PixUsuariosCadastradosDICT OK            1.72 
 # \dontrun{}
```
