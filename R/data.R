
#' Comit\u00eas de Bacia Hidrogr\u00e1fica no Estado de S\u00e3o Paulo
#'
#' Tabela agregada \u00e0 partir de dados obtidos no SigRH \url{http://www.sigrh.sp.gov.br/municipios}.
#'
#' @format Uma tibble com 22 linhas (cada uma representando uma UGRHI) e 5 colunas, contendo as vari\u00e1veis:
#' \describe{
#'   \item{bacia_hidrografica}{Nome da Bacia Hidrogr\u00e1fica}
#'   \item{sigla_comite}{Sigla utilizada no site do SigRH para o Comit\u00ea}
#'   \item{n_ugrhi}{N\u00famero que representa a Unidade de Gerenciamento de Recursos H\u00eddricos \u00e0 qual o Comit\u00ea est\u00e1 relacionado}
#'   \item{numero_municipios}{N\u00famero de munic\u00edpios que pertencem \u00e0 Unidade de Gerenciamento de Recursos H\u00eddricos \u00e0 qual o Comit\u00ea est\u00e1 relacionado}
#'   \item{macrometropole_daee}{Vari\u00e1vel l\u00f3gica. Caso seja TRUE, este Comit\u00ea est\u00e1 parcialmente ou totalmente no territ\u00f3rio da Macrometr\u00f3pole Paulista, segundo a delimita\u00e7\u00e3o do DAEE ( \url{http://www.sigrh.sp.gov.br/}).}
#' }
#' @name comites_sp
#' @source SigRH - \url{http://www.sigrh.sp.gov.br/municipios}
#' @examples comites_sp
#'
"comites_sp"
















#' Representantes dos Comit\u00eas de Bacia Hidrogr\u00e1fica no Estado de S\u00e3o Paulo
#'
#' Tabela contendo informa\u00e7\u00f5es sobre representantes dos Comit\u00eas de Bacia Hidrogr\u00e1fica no Estado de S\u00e3o Paulo
#'
#' @format Uma tibble, contendo:
#' \describe{
#'   \item{data_coleta_dados}{Data em que os dados foram coletados, no formato ano-m\u00eas-dia (yyyy-mm-dd)}
#'   \item{site_coleta}{Link do site onde os dados foram coletados}
#'   \item{comite}{Nome do comit\u00ea de Bacia Hidrogr\u00e1fica}
#'   \item{n_ugrhi}{N\u00famero que representa a Unidade de Gerenciamento de Recursos H\u00eddricos \u00e0 qual o Comit\u00ea est\u00e1 relacionado}
#'   \item{organizacao_representante}{Organiza\u00e7\u00e3o representante \u00e0 qual a pessoa na coluna 'nome' est\u00e1 vinculada, segundo informado pelo Comit\u00ea de Bacia}
#'   \item{nome}{Nome da pessoa representante, segundo informado pelo Comit\u00ea de Bacia}
#'   \item{email}{Email da pessoa representante, segundo informado pelo Comit\u00ea de Bacia}
#'   \item{cargo}{Cargo (Titular ou Suplente) da pessoa representante, segundo informado pelo Comit\u00ea de Bacia}
#' }
#' @name representantes_comites
#' @source SigRH - \url{http://www.sigrh.sp.gov.br/}
#' @examples head(representantes_comites)
"representantes_comites"



















#' Atas de reuni\u00f5es dos Comit\u00eas de Bacia Hidrogr\u00e1fica no Estado de S\u00e3o Paulo
#'
#' Tabela contendo informa\u00e7\u00f5es sobre reuni\u00f5es dos Comit\u00eas de Bacia Hidrogr\u00e1fica no Estado de S\u00e3o Paulo e link para as atas de reuni\u00e3o.
#'
#' @format Uma tibble, contendo:
#' \describe{
#'   \item{data_coleta_dados}{Data em que os dados foram coletados, no formato ano-m\u00eas-dia (yyyy-mm-dd)}
#'   \item{site_coleta}{Link do site onde os dados foram coletados}
#'   \item{comite}{Nome do comit\u00ea de bacia}
#'   \item{n_ugrhi}{N\u00famero que representa a Unidade de Gerenciamento de Recursos H\u00eddricos \u00e0 qual o Comit\u00ea est\u00e1 relacionado}
#'   \item{nome_reuniao}{Nome da reuni\u00e3o, segundo informado pelo Comit\u00ea de Bacia}
#'   \item{data_reuniao}{Data da reuni\u00e3o, segundo informado pelo Comit\u00ea de Bacia, no formato ano-m\u00eas-dia (yyyy-mm-dd)}
#'   \item{data_postagem}{Data da postagem da ata de reuni\u00e3o, segundo informado pelo Comit\u00ea de Bacia, no formato ano-m\u00eas-dia (yyyy-mm-dd)}
#'   \item{numero_link}{Em alguns casos, h\u00e1 mais de um link para o arquivo da ata por reuni\u00e3o. Essa coluna cont\u00e9m a ordem dos arquivos.}
#'   \item{url_link}{URL, ou endere\u00e7o online, do arquivo referente \u00e0 ata da reuni\u00e3o.}
#' }
#' @name atas_comites
#' @source SigRH - \url{http://www.sigrh.sp.gov.br/}
#'@examples atas_comites %>% dplyr::arrange(desc(data_postagem)) %>% head(10)
"atas_comites"

