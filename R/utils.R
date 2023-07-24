tratar_vazio <- function(x) {
  classe <- class(x)
  if (classe[1] == "tbl_df") {
    if (nrow(x) == 0) {
      x <- tibble::tibble(arquivos = list(NA_character_))
    }
  } else if(length(x) == 0 ){
    x <- NA_character_
  } else if (is.na(x) | is.null(x)) {
    x <- NA_character_
  }

  x
}
