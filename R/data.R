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
















#' Representantes dos Comitês de Bacia Hidrográfica no Estado de São Paulo
#'
#' Tabela contendo informações sobre representantes dos Comitês de Bacia Hidrográfica no Estado de São Paulo
#'
#' @format Uma tibble, contendo:
#' \describe{
#'   \item{data_coleta_dados}{Data em que os dados foram coletados, no formato ano-mês-dia (yyyy-mm-dd)}
#'   \item{site_coleta}{Link do site onde os dados foram coletados}
#'   \item{comite}{Nome do comitê de Bacia Hidrográfica}
#'   \item{n_ugrhi}{Número que representa a Unidade de Gerenciamento de Recursos Hídricos à qual o Comitê está relacionado}
#'   \item{organizacao_representante}{Organização representante à qual a pessoa na coluna 'nome' está vinculada, segundo informado pelo Comitê de Bacia}
#'   \item{nome}{Nome da pessoa representante, segundo informado pelo Comitê de Bacia}
#'   \item{email}{Email da pessoa representante, segundo informado pelo Comitê de Bacia}
#'   \item{cargo}{Cargo (Titular ou Suplente) da pessoa representante, segundo informado pelo Comitê de Bacia}
#' }
#' @name representantes_comites
#' @source SigRH - \url{https://sigrh.sp.gov.br/}
#' @examples head(representantes_comites)
"representantes_comites"



















#' Atas de reuniões dos Comitês de Bacia Hidrográfica no Estado de São Paulo
#'
#' Tabela contendo informações sobre reuniões dos Comitês de Bacia Hidrográfica no Estado de São Paulo e link para as atas de reunião.
#'
#' @format Uma tibble, contendo:
#' \describe{
#'   \item{data_coleta_dados}{Data em que os dados foram coletados, no formato ano-mês-dia (yyyy-mm-dd)}
#'   \item{site_coleta}{Link do site onde os dados foram coletados}
#'   \item{comite}{Nome do comitê de bacia}
#'   \item{n_ugrhi}{Número que representa a Unidade de Gerenciamento de Recursos Hídricos à qual o Comitê está relacionado}
#'   \item{nome_reuniao}{Nome da reunião, segundo informado pelo Comitê de Bacia}
#'   \item{data_reuniao}{Data da reunião, segundo informado pelo Comitê de Bacia, no formato ano-mês-dia (yyyy-mm-dd)}
#'   \item{data_postagem}{Data da postagem da ata de reunião, segundo informado pelo Comitê de Bacia, no formato ano-mês-dia (yyyy-mm-dd)}
#'   \item{numero_link}{Em alguns casos, há mais de um link para o arquivo da ata por reunião. Essa coluna contém a ordem dos arquivos.}
#'   \item{url_link}{URL, ou endereço online, do arquivo referente à ata da reunião.}
#' }
#' @name atas_comites
#' @source SigRH - \url{https://sigrh.sp.gov.br/}
#'@examples atas_comites %>% dplyr::arrange(desc(data_postagem)) %>% head(10)
"atas_comites"
