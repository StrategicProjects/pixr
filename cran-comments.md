# pixr 0.1.1

## R CMD check results

0 errors | 0 warnings | 0 notes

## Changes in this release

This is a minor update to the package:

* Added support for two endpoints introduced in the upstream API:
  `get_pix_cnae_stats()` (CnaePorteRecebedor) and `get_pix_dict_users()`
  (PixUsuariosCadastradosDICT).
* Updated author metadata: added ORCID iDs for all authors.
* Fixed the User-Agent string sent with API requests (it pointed to a
  placeholder URL).
* `top` and column name inputs are now validated with clear messages.
* Added a unit test suite for the offline helpers (no tests hit the API).
* NEWS.md is now included in the package build.

## URLs

The BCB API URLs (olinda.bcb.gov.br) may return 403 to automated URL
checkers; they load normally in a browser. These are the same URLs
accepted in the 0.1.0 submission.

## Test environments

* Local: macOS, R 4.6.0
* All examples that call the web API are wrapped in \donttest{} or
  \dontrun{}, as in the previous release, since they depend on external
  API availability and may take longer than 5 seconds.
