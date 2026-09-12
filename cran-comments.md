## R CMD check results

0 errors | 0 warnings | 1 note

* This is a resubmission.

## Resubmission

This is a resubmission. In this version I have addressed the comments from Konstanze Lauseker:

### 1. Single quotes around BCB
- Removed the 'BCB' acronym from the DESCRIPTION file and replaced it with the full API web reference.

### 2. Web reference for API
- Added the API web reference with angle brackets for auto-linking in the Description field:
```
<https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/aplicacao#!/recursos>
```

### 3. Examples with \dontrun{}
- Replaced `\dontrun{}` with `\donttest{}` for all examples that require API calls, 
  as they depend on external API availability and may take *longer than 5 seconds*
  due to network latency.

## Uwe Ligges: Found the following (possibly) invalid URLs
  - URL: https://github.com/yourname/pixr/actions/workflows/R-CMD-check.yaml
  - Thank you for your feedback. The invalid URL has been corrected. 