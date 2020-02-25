#' Extract file format
#'
#' Extract the file format from a url. If is NA, returns a NA.
#'
#' @param url character
#'
#' @return character
#' @export
#'
#' @examples
#' file <- "https://github.com/hadley/pkg-dev/blob/master/1-intro.pdf"
#' get_file_format(file)

get_file_format <- function(url) {
  ifelse(
    is.na(url),
    NA,
    stringr::str_extract(url, pattern = "(.doc|.docx|.pdf|.html|.htm|.jpg|.pd)$|drive.google")
  )
}
