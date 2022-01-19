#' Comitês de Bacia Hidrográfica no Estado de São Paulo
#'
#' Tabela agregada à partir de dados obtidos no SigRH \url{https://sigrh.sp.gov.br/municipios}.
#'
#' @format Uma tibble com 22 linhas (cada uma representando uma UGRHI) e 5 colunas, contendo as variáveis:
#' \describe{
#'   \item{bacia_hidrografica}{Nome da Bacia Hidrográfica}
#'   \item{sigla_comite}{Sigla utilizada no site do SigRH para o Comitê}
#'   \item{n_ugrhi}{Número que representa a Unidade de Gerenciamento de Recursos Hídricos à qual o Comitê está relacionado}
#'   \item{numero_municipios}{Número de municípios que pertencem à Unidade de Gerenciamento de Recursos Hídricos à qual o Comitê está relacionado}
#'   \item{macrometropole_daee}{Variável lógica. Caso seja TRUE, este Comitê está parcialmente ou totalmente no território da Macrometrópole Paulista, segundo a delimitação do DAEE ( \url{http://www.sigrh.sp.gov.br/}).}
#' }
#' @name comites_sp
#' @source SigRH - \url{https://sigrh.sp.gov.br/municipios}
#' @examples comites_sp
#'
"comites_sp"


#' Agências de Bacia Hidrográfica no Estado de São Paulo
#'
#' Tabela agregada à partir de dados obtidos no SigRH \url{https://sigrh.sp.gov.br/}.
#'
#' @format Uma tibble com 4 linhas (cada uma representando uma agência) e 7 colunas, contendo as variáveis:
#' \describe{
#'   \item{nome}{Nome da agência}
#'   \item{sigla}{Sigla utilizada no site do SigRH para a agência}
#'   \item{sigla_agencia}{Sigla utilizada no site do SigRH para a agência,
#'    em letras minúsculas e sem acentuação (como usado nas urls de acesso ao site). }
#'   \item{sigla_ugrhi}{Sigla utilizada no site do SigRH para a UGRHI}
#'   \item{url_atas}{URL da página no SigRH onde essa agência disponibiliza atas}
#'   \item{site_sigrh}{URL da página da agência no SigRH}
#'   \item{site_alternativo}{URL da página da agência externa ao SigRH}
#' }
#' @name agencias_de_bacia_sp
#' @source SigRH - \url{https://sigrh.sp.gov.br/}
#' @examples agencias_de_bacia_sp
#'
"agencias_de_bacia_sp"
