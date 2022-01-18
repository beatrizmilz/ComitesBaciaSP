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
