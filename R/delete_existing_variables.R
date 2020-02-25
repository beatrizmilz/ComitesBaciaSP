#' Title
#'
#' @param var
#'
#' @return
#' @export
#'
#' @examples


delete_existing_variables <- function(var) {
  if (exists(as.character(var)) == TRUE) {
    rm(var)
    print(glue::glue("Variávei {var} deletada com sucesso!"))
  }
}

