# pixr — project notes for Claude

R package: tidyverse-style client for the **Brazilian Central Bank (BCB)
PIX Open Data API** (Olinda / OData). Returns tibbles. Python
counterpart: `../pixbr` (PyPI). Sibling package with the canonical
author metadata: `../alepe`.

- **Repo:** <https://github.com/StrategicProjects/pixr> (public, branch
  `main`).
- **CRAN:** 0.1.0 published; **0.1.1 submitted 2026-10-28** (in
  `incoming/pretest`). After acceptance: tag `v0.1.1`, delete
  `CRAN-SUBMISSION`.
- **Docs site:** <https://strategicprojects.github.io/pixr/> — GitHub
  Pages, deployed by `.github/workflows/pkgdown.yaml` to the `gh-pages`
  branch. `docs/` is NOT tracked on `main` (gitignored). The old
  `monitoramento.pe.gov.br/pixr` host never resolved; don’t reintroduce
  it.

## Endpoints (6 since 0.1.1)

| Endpoint | Param | Function |
|----|----|----|
| `ChavesPix` | `Data` (YYYY-MM-DD) | [`get_pix_keys()`](https://strategicprojects.github.io/pixr/reference/get_pix_keys.md) |
| `TransacoesPixPorMunicipio` | `DataBase` (YYYYMM) | [`get_pix_transactions_by_municipality()`](https://strategicprojects.github.io/pixr/reference/get_pix_transactions_by_municipality.md) |
| `EstatisticasTransacoesPix` | `Database` (YYYYMM) | [`get_pix_transaction_stats()`](https://strategicprojects.github.io/pixr/reference/get_pix_transaction_stats.md) |
| `EstatisticasFraudesPix` | `Database` (YYYYMM) | [`get_pix_fraud_stats()`](https://strategicprojects.github.io/pixr/reference/get_pix_fraud_stats.md) |
| `CnaePorteRecebedor` | `Database` (YYYYMM) | [`get_pix_cnae_stats()`](https://strategicprojects.github.io/pixr/reference/get_pix_cnae_stats.md) |
| `PixUsuariosCadastradosDICT` | (none) | [`get_pix_dict_users()`](https://strategicprojects.github.io/pixr/reference/get_pix_dict_users.md) |

- **All data is monthly** (DICT users series: one obs per month-end
  since 2020-11). No daily data in this API.
- **Gotcha:** on `CnaePorteRecebedor` and the municipality endpoint,
  `Database` selects the data *snapshot*, not the month — responses mix
  several `AnoMes`. Filter with `AnoMes eq YYYYMM` for a single month.
- To check for new endpoints, fetch the OData `$metadata` and diff
  EntityType/FunctionImport against
  [`pix_endpoints()`](https://strategicprojects.github.io/pixr/reference/pix_endpoints.md).

## Delicate parts

- **URL building** (`R/client.R pix_request()`): the BCB API is picky —
  only spaces are percent-encoded (`%20`), nothing else. curl handles
  raw UTF-8 in filters (accents work). Don’t switch to standard URL
  encoding.
- `skip` is not supported by the API → warn and omit.
- cli pluralization: `{?s}` needs a quantity expression *before* it in
  the same string, or `cli_warn`/`cli_abort` throws (this bit us once in
  `validate_columns()`).
- BCB URLs (olinda.bcb.gov.br) return **403 to bots** but 200 in
  browsers; CRAN accepted them — keep the note in `cran-comments.md`.
- pkgdown: every vignette must appear in the `articles:` index of
  `_pkgdown.yml` (navbar menu alone is not enough; the site build
  fails).

## Dev workflow

``` r

roxygen2::roxygenise()
devtools::test()        # 87 offline tests; nothing hits the API
devtools::check()       # 0/0/0 expected
devtools::build(path = ".")   # CRAN tarball
devtools:::upload_cran(devtools::as.package("."), "pixr_X.Y.Z.tar.gz")
```

CI: `.github/workflows/R-CMD-check.yaml` (5 platforms; macOS arm64
runners sometimes fail with “job was not acquired” — GitHub capacity,
just rerun) and `pkgdown.yaml`.

## Conventions

- Author list and order are canonical in `../alepe/DESCRIPTION` (Leite,
  Wasiliew, Vasconcelos, Amorim, Bezerra, Nascimento Barreto, all with
  ORCIDs). Keep pixr/pixbr aligned.
- Examples hitting the API use `\donttest{}` (or `\dontrun{}` for
  `pix_ping`/`pix_query`) — CRAN reviewer required this in 0.1.0.
- Vignettes use `eval = FALSE` with real captured output pasted as `#>`
  comments; refresh outputs against the live API when touching them.
