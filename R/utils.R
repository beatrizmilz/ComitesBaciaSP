tratar_vazio <- function(x) {
  classe <- class(x)
  if (classe[1] == "tbl_df") {
    if (nrow(x) == 0) {
      x <- tibble::tibble(arquivos = list(NA))
    }
  } else if(length(x) == 0 ){
    x <- NA
  } else if (is.na(x) | is.null(x)) {
    x <- NA
  }

  x
}
