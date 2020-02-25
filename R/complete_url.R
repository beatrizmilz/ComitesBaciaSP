#' Title
#'
#' @param url
#'
#' @return
#' @export
#'
#' @examples
#'
#'
complete_url <- function(url) {
  if(length(url) == 0){
    NA
  } else if (is.na(url)) {
    NA
  } else if (stringr::str_starts(url , "/public")) {
    paste0("http://www.sigrh.sp.gov.br", url)
  } else{
    url
  }
}
