
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ComitesBaciaSP

<!-- badges: start -->

[![R build
status](https://github.com/beatrizmilz/ComitesBaciaSP/workflows/R-CMD-check/badge.svg)](https://github.com/beatrizmilz/ComitesBaciaSP/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

O objetivo deste pacote é disponibilizar funções para raspar dados sobre
os Comitês de Bacias Hidrográficas do Estado de São Paulo, disponíveis
de forma não estruturada no site [SigRH](http://www.sigrh.sp.gov.br/),
assim como disponibilizar as bases de dados raspadas, de forma a
facilitar a análise dos mesmos.

Este pacote foi criado no âmbito da [pesquisa de doutorado de Beatriz
Milz](https://beatrizmilz.github.io/tese/).

## Instalação do pacote

Este pacote pode ser instalado através do [GitHub](https://github.com/)
utilizando o seguinte código em `R`:

``` r
# install.packages("devtools")
devtools::install_github("beatrizmilz/ComitesBaciaSP")
```

## Utilização do pacote

``` r
library(ComitesBaciaSP)
```

Para utilizar as funções do pacote, primeiramente é necessário saber o
número referente ao comitê que você deseja buscar informações:

``` r
comites_sp %>%
  dplyr::select(nome_ugrhi, n_ugrhi) %>%
  knitr::kable(col.names = c("Nome", "Número"))
```

| Nome                          | Número |
| :---------------------------- | -----: |
| Paraíba do Sul                |      2 |
| Litoral Norte                 |      3 |
| Piracicaba/Capivari/Jundiaí   |      5 |
| Alto Tietê                    |      6 |
| Baixada Santista              |      7 |
| Mogi-Guaçu                    |      9 |
| Tietê/Sorocaba                |     10 |
| Ribeira de Iguape/Litoral Sul |     11 |

### Busca de atas

A função seguinte busca informações disponíveis sobre as atas dos
comitês de bacia:

``` r
obter_tabela_atas_comites(6) %>% # O 6 é o número referente à bacia Alto Tietê
  head() %>%  # filtra apenas as primeiras linhas
  knitr::kable() # formata a tabela
```

| data\_coleta\_dados | comite     | comite\_numero | nome\_reuniao                                                   | data\_reuniao | data\_postagem | numero\_link | url\_link                                                                                                                                      | formato\_link |
| :------------------ | :--------- | -------------: | :-------------------------------------------------------------- | :------------ | :------------- | :----------- | :--------------------------------------------------------------------------------------------------------------------------------------------- | :------------ |
| 2020-10-12          | Alto Tietê |              6 | Resumo Executivo da 1ª reunião extraordinária do CBH-AT de 2020 | 2020-02-20    | 2020-07-29     | ata\_1       | <http://www.sigrh.sp.gov.br/public/uploads/records//CBH-AT/18944/1-reuniao-20-02-2020.pdf>                                                     | .pdf          |
| 2020-10-12          | Alto Tietê |              6 | Resumo Executivo da 6ª Reunião Plenária Extraordinária de 2019  | 2019-12-17    | 2020-02-21     | ata\_1       | <http://www.sigrh.sp.gov.br/public/uploads/records//CBH-AT/18770/6-reuniao-17-12-2019.pdf>                                                     | .pdf          |
| 2020-10-12          | Alto Tietê |              6 | Plenária CBH-AT 25/09/2019                                      | 2019-09-25    | 2019-10-01     | ata\_1       | <http://www.sigrh.sp.gov.br/public/uploads/records//CBH-AT/17560/resumo-executivo-da-3-reuniao-plenaria-de-2019-24-07-2019.pdf>                | .pdf          |
| 2020-10-12          | Alto Tietê |              6 | Plenária CBH-AT 24/07/2019                                      | 2019-07-24    | 2019-08-13     | ata\_1       | <http://www.sigrh.sp.gov.br/public/uploads/records//CBH-AT/17449/resumo-executivo-da-3-reuniao-plenaria-extraordinaria-de-2019-24-07-2019.pdf> | .pdf          |
| 2020-10-12          | Alto Tietê |              6 | Plenária CBH-AT 29/03/2019                                      | 2019-03-29    | 2019-08-13     | ata\_1       | <http://www.sigrh.sp.gov.br/public/uploads/records//CBH-AT/17448/resumo-executivo-da-2-reuniao-plenaria-ordinaria-de-2019-29-03-2019.pdf>      | .pdf          |
| 2020-10-12          | Alto Tietê |              6 | Plenária CBH-AT 14/03/2019                                      | 2019-03-14    | 2019-08-13     | ata\_1       | <http://www.sigrh.sp.gov.br/public/uploads/records//CBH-AT/17447/resumo-executivo-da-1-reuniao-plenaria-extraordinaria-de-2019-14-03-2019.pdf> | .pdf          |

``` r
reunioes_disponiveis_por_comite <- tabela_atas_comites %>%
  dplyr::filter(numero_link == "ata_1") %>%
  dplyr::group_by(comite, comite_numero) %>%
  dplyr::count()

knitr::kable(reunioes_disponiveis_por_comite)
```

| comite                        | comite\_numero |   n |
| :---------------------------- | -------------: | --: |
| Alto Tietê                    |              6 | 140 |
| Baixada Santista              |              7 | 136 |
| Litoral Norte                 |              3 |  56 |
| Mogi-Guaçu                    |              9 |  84 |
| Piracicaba/Capivari/Jundiaí   |              5 |  90 |
| Ribeira de Iguape/Litoral Sul |             11 | 110 |
| Tietê/Sorocaba                |             10 |  99 |
