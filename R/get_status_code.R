#' Title
#'
#' @param url character
#'
#' @return
#' @export
#'
#' @import magrittr
#' @import httr
#' @examples
#' file <- "https://github.com/hadley/pkg-dev/blob/master/1-intro.pdf"
#' get_status_code(file)
#'
get_status_code <- function(url) {
  if (is.na(url)) {
    NA
  } else {
    get <- url %>% httr::GET()
    httr::status_code(get)
  }
}
