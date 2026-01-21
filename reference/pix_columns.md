# Get Column Information for a PIX Endpoint

Returns detailed information about the columns available for a specific
endpoint.

## Usage

``` r
pix_columns(endpoint = c("keys", "municipality", "stats", "fraud"))
```

## Arguments

- endpoint:

  Character string specifying the endpoint. One of: "keys",
  "municipality", "stats", or "fraud".

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with column names, types, and descriptions.

## Examples

``` r
pix_columns("keys")
#> # A tibble: 6 × 3
#>   column          type      description                                        
#>   <chr>           <chr>     <chr>                                              
#> 1 Data            character Reference date (YYYY-MM-DD, last day of month)     
#> 2 ISPB            character 8-digit code identifying the financial institution 
#> 3 Nome            character Name of the PIX participant (financial institution)
#> 4 NaturezaUsuario character User type: PF (Individual) or PJ (Legal Entity)    
#> 5 TipoChave       character Key type: CPF, CNPJ, Celular, e-mail, or Aleatória 
#> 6 qtdChaves       numeric   Number of registered keys                          
pix_columns("municipality")
#> # A tibble: 19 × 3
#>    column             type      description                                     
#>    <chr>              <chr>     <chr>                                           
#>  1 AnoMes             integer   Reference year-month (YYYYMM format)            
#>  2 Municipio_Ibge     integer   IBGE municipality code                          
#>  3 Municipio          character Municipality name                               
#>  4 Estado_Ibge        integer   IBGE state code                                 
#>  5 Estado             character State name                                      
#>  6 Sigla_Regiao       character Region abbreviation (NE, SE, S, CO, N)          
#>  7 Regiao             character Region name                                     
#>  8 VL_PagadorPF       numeric   Value paid by individuals (BRL)                 
#>  9 QT_PagadorPF       numeric   Count of transactions with individual payers    
#> 10 VL_PagadorPJ       numeric   Value paid by legal entities (BRL)              
#> 11 QT_PagadorPJ       numeric   Count of transactions with legal entity payers  
#> 12 VL_RecebedorPF     numeric   Value received by individuals (BRL)             
#> 13 QT_RecebedorPF     numeric   Count of transactions with individual receivers 
#> 14 VL_RecebedorPJ     numeric   Value received by legal entities (BRL)          
#> 15 QT_RecebedorPJ     numeric   Count of transactions with legal entity receive…
#> 16 QT_PES_PagadorPF   numeric   Distinct individual payers                      
#> 17 QT_PES_PagadorPJ   numeric   Distinct legal entity payers                    
#> 18 QT_PES_RecebedorPF numeric   Distinct individual receivers                   
#> 19 QT_PES_RecebedorPJ numeric   Distinct legal entity receivers                 
pix_columns("stats")
#> # A tibble: 12 × 3
#>    column         type      description                                         
#>    <chr>          <chr>     <chr>                                               
#>  1 AnoMes         integer   Reference year-month (YYYYMM format)                
#>  2 PAG_PFPJ       character Payer type: PF (Individual) or PJ (Legal Entity)    
#>  3 REC_PFPJ       character Receiver type: PF or PJ                             
#>  4 PAG_REGIAO     character Payer region (NORTE, NORDESTE, SUDESTE, SUL, CENTRO…
#>  5 REC_REGIAO     character Receiver region                                     
#>  6 PAG_IDADE      character Payer age group                                     
#>  7 REC_IDADE      character Receiver age group                                  
#>  8 FORMAINICIACAO character Initiation method (DICT, QRDN, QRES, MANU, INIC)    
#>  9 NATUREZA       character Transaction nature (P2P, P2B, B2P, B2B, P2G, G2P)   
#> 10 FINALIDADE     character Transaction purpose (Pix, Pix Saque, Pix Troco)     
#> 11 VALOR          numeric   Total transaction value (BRL)                       
#> 12 QUANTIDADE     numeric   Number of transactions                              
pix_columns("fraud")
#> # A tibble: 2 × 3
#>   column   type    description                                          
#>   <chr>    <chr>   <chr>                                                
#> 1 AnoMes   integer Reference year-month (YYYYMM format)                 
#> 2 (varies) varies  Fraud statistics columns - use API to see full schema
```
