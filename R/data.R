
#' Comitês de Bacia Hidrográfica no Estado de São Paulo
#'
#' MUDAR ISSO Base de dados contendo informações sobre os Sistemas
#' que abastecem a Região Metropolitana de São Paulo
#'
#' @format Uma tibble, contendo:
#' \describe{
#'   \item{data}{Data no formato ano-mês-dia (yyyy-mm-dd)}
#'   \item{sistema}{Nome do sistema de abastecimento público}
#'   \item{volume_porcentagem}{Volume operacional do sistema em porcentagem (%)}
#'   \item{volume_variacao}{Variação em porcentagem (%) do volume operacional do sistema}
#'   \item{volume_operacional}{Volume operacional do sistema em hm³}
#'   \item{pluviometria_dia}{Pluviometria do dia (mm)}
#'   \item{pluviometria_mensal}{Pluviometria acumulada do mês (mm)}
#'   \item{pluviometria_hist}{Pluviometria média histórica mensal (mm)}
#'
#' }
#' @name comites_sp
#' @source SigRH - \url{http://www.sigrh.sp.gov.br/}
#'
"comites_sp"

