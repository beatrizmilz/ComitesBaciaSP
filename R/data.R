
#' Comitês de Bacia Hidrográfica no Estado de São Paulo
#'
#' Tabela agregada à partir de dados obtidos no SigRH \url{http://www.sigrh.sp.gov.br/municipios}.
#'
#' @format Uma tibble com 22 linhas (cada uma representando uma UGRHI) e 5 colunas, contendo as variáveis:
#' \describe{
#'   \item{bacia_hidrografica}{Nome da Bacia Hidrográfica}
#'   \item{sigla_comite}{Sigla utilizada no site do SigRH para o Comitê}
#'   \item{n_ugrhi}{Número que representa a Unidade de Gerenciamento de Recursos Hídricos à qual o Comitê está relacionado}
#'   \item{numero_municipios}{Número de municípios que pertencem à Unidade de Gerenciamento de Recursos Hídricos à qual o Comitê está relacionado}
#'   \item{macrometropole_daee}{Variável lógica. Caso a resposta seja TRUE, este Comitê está parcialmente ou totalmente no território da Macrometrópole Paulista, segundo a delimitação do DAEE.}
#' }
#' @name comites_sp
#' @source SigRH - \url{http://www.sigrh.sp.gov.br/municipios}
#' @examples knitr::kable(comites_sp)
#'
"comites_sp"



#' Representantes dos Comitês de Bacia Hidrográfica no Estado de São Paulo
#'
#' MUDAR ISSO
#'
#' @format Uma tibble, contendo:
#' \describe{
#'   \item{data_coleta_dados}{Data em que os dados foram coletados, no formato ano-mês-dia (yyyy-mm-dd)}
#'   \item{comite}{Nome do comit}
#' }
#' @name representantes_comites
#' @source SigRH - \url{http://www.sigrh.sp.gov.br/}
#'
"representantes_comites"

#' Atas de reuniões dos Comitês de Bacia Hidrográfica no Estado de São Paulo
#'
#' Tabela contendo informações sobre reuniões dos Comitês de Bacia Hidrográfica no Estado de São Paulo e link para as atas de reunião.
#'
#' @format Uma tibble, contendo:
#' \describe{
#'   \item{data_coleta_dados}{Data em que os dados foram coletados, no formato ano-mês-dia (yyyy-mm-dd)}
#'   \item{comite}{Nome do comitê de bacia}
#'   \item{n_ugrhi}{Número que representa a Unidade de Gerenciamento de Recursos Hídricos à qual o Comitê está relacionado}
#'   \item{nome_reuniao}{Nome da reunião, segundo informado pelo Comitê de Bacia}
#'   \item{data_reuniao}{Data da reunião, segundo informado pelo Comitê de Bacia, no formato ano-mês-dia (yyyy-mm-dd)}
#'   \item{data_postagem}{Data da postagem da ata de reunião, segundo informado pelo Comitê de Bacia, no formato ano-mês-dia (yyyy-mm-dd)}
#'   \item{numero_link}{Em alguns casos, há mais de um link para o arquivo da ata por reunião. Essa coluna contém a ordem dos arquivos.}
#'   \item{url_link}{URL, ou endereço online, do arquivo referente à ata da reunião.}
#' }
#' @name atas_comites
#' @source SigRH - \url{http://www.sigrh.sp.gov.br/}
#'
"atas_comites"

