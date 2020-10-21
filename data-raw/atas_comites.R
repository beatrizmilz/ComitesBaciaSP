## code to prepare `atas_comites` dataset goes here

siglas_dos_comites <- comites_sp %>%
  dplyr::pull(sigla_comite) %>%
  unique()

atas_comites <-
  purrr::map_df(siglas_dos_comites, obter_tabela_atas_comites)

atas_comites %>%
  write.csv2(
    file = glue::glue("inst/extdata/tabela_atas_comites_{Sys.Date()}.csv"),
    fileEncoding = "UTF-8"
  )

usethis::use_data(atas_comites, overwrite = TRUE)
