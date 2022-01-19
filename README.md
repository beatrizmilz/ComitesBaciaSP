
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ComitesBaciaSP

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/beatrizmilz/ComitesBaciaSP/workflows/R-CMD-check/badge.svg)](https://github.com/beatrizmilz/ComitesBaciaSP/actions)
<!-- badges: end -->

O objetivo deste pacote é disponibilizar funções para obter dados sobre
os Comitês de Bacias Hidrográficas do Estado de São Paulo, disponíveis
de forma não estruturada no site [SigRH](https://sigrh.sp.gov.br/).

Este pacote foi criado no âmbito da pesquisa de doutorado de [Beatriz
Milz](https://beatrizmilz.com). As funções do pacote estão sendo
desenvolvidas à medida que são necessárias na pesquisa, porém se você
necessita de algum dado que se encaixa no contexto deste pacote,
[escreva uma
issue](https://github.com/beatrizmilz/ComitesBaciaSP/issues/new/choose)
descrevendo as informações necessárias para que seja avaliado à
possibilidade de desenvolver e incorporar a sugestão no pacote.

## Instalação do pacote

Este pacote pode ser instalado através do [GitHub](https://github.com/)
utilizando o seguinte código em `R`:

``` r
# install.packages("devtools")
devtools::install_github("beatrizmilz/ComitesBaciaSP")
```

## Utilização do pacote

É possível carregar o pacote utilizando a seguinte função:

``` r
library(ComitesBaciaSP)
```

-   As bases disponíveis no pacote atualmente são:
    -   [`comites_sp`](https://beatrizmilz.github.io/ComitesBaciaSP/reference/comites_sp.html)
    -   [`agencias_de_bacia_sp`](https://beatrizmilz.github.io/ComitesBaciaSP/reference/agencias_de_bacia_sp.html)
-   As funções disponíveis no pacote atualmente são:
    -   [`raspar_pagina_sigrh`()](https://beatrizmilz.github.io/ComitesBaciaSP/reference/raspar_pagina_sigrh.html)
    -   [`download_pagina_sigrh`()](https://beatrizmilz.github.io/ComitesBaciaSP/reference/download_pagina_sigrh.html)

Para utilizar as funções do pacote, é necessário saber a sigla referente
ao comitê que você deseja buscar informações. A base comites_sp
disponibiliza esta informação:

``` r
comites_sp %>%
  dplyr::select(1:3) %>% 
  knitr::kable(col.names = c("Nome", "Sigla", "Número"))
```

| Nome                            | Sigla | Número |
|:--------------------------------|:------|-------:|
| Serra da Mantiqueira            | sm    |      1 |
| Paraíba do Sul                  | ps    |      2 |
| Litoral Norte                   | ln    |      3 |
| Pardo                           | pardo |      4 |
| Piracicaba / Capivari / Jundiaí | pcj   |      5 |
| Alto Tietê                      | at    |      6 |
| Baixada Santista                | bs    |      7 |
| Sapucaí-Mirim / Grande          | smg   |      8 |
| Mogi-Guaçu                      | mogi  |      9 |
| Sorocaba e Médio Tietê          | smt   |     10 |
| Ribeira do Iguape e Litoral Sul | rb    |     11 |
| Baixo Pardo / Grande            | bpg   |     12 |
| Tietê-Jacaré                    | tj    |     13 |
| Alto Paranapanema               | alpa  |     14 |
| Turvo / Grande                  | tg    |     15 |
| Tietê-Batalha                   | tb    |     16 |
| Médio Paranapanema              | mp    |     17 |
| São José dos Dourados           | sjd   |     18 |
| Baixo Tietê                     | bt    |     19 |
| Aquapeí e Peixe                 | ap    |     20 |
| Aquapeí e Peixe                 | ap    |     21 |
| Pontal do Paranapanema          | pp    |     22 |

Obs: As UGRHIs 20 - Aquapeí e 21 - Peixe integram o “Comitê das Bacias
Hidrográficas dos Rios Aguapeí e Peixe – CBH-AP”, e por isso o CBH-AP
aparece duas vezes na tabela.

## Como citar o pacote

``` r
citation("ComitesBaciaSP")
#> 
#> To cite ComitesBaciaSP in publications use:
#> 
#>   Beatriz Milz (2020). ComitesBaciaSP - Pacote com dados sobre os
#>   Comitês de Bacias Hidrográficas no Estado de São Paulo (SP - Brasil).
#>   R package version 0.0.0.9000.
#>   https://beatrizmilz.github.io/ComitesBaciaSP/
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {ComitesBaciaSP - Pacote com dados sobre os Comitês de Bacias Hidrográficas no Estado de São Paulo (SP - Brasil)},
#>     author = {{Beatriz Milz}},
#>     year = {2020},
#>     note = {R package version 0.0.0.9000},
#>     url = {https://beatrizmilz.github.io/ComitesBaciaSP/},
#>   }
```

## Pacotes relacionados ao tema

-   [Pacote Mananciais](https://beatrizmilz.github.io/mananciais/),
    desenvolvido por [Beatriz Milz](https://beatrizmilz.com):
    disponibiliza a base de dados sobre o volume operacional em
    mananciais de abastecimento público na Região Metropolitana de São
    Paulo (SP - Brasil).

-   [Pacote
    reservatoriosBR](https://brunomioto.github.io/reservatoriosBR/),
    desenvolvido por [Bruno Mioto](https://www.brunomioto.com.br/):
    Pacote para obtenção de dados dos principais reservatórios
    brasileiros a partir da plataforma SAR-ANA e da ONS.
