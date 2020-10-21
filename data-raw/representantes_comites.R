## code to prepare `representantes_comites` dataset goes here

siglas_dos_comites <- comites_sp %>%
  dplyr::pull(sigla_comite) %>%
  unique()


representantes_comites <-
  purrr::map_df(siglas_dos_comites, obter_tabela_representantes_comites)

representantes_comites %>%
  write.csv2(
    file = glue::glue(
      "inst/extdata/tabela_representantes_comites_{Sys.Date()}.csv"
    ),
    fileEncoding = "UTF-8"
  )

usethis::use_data(representantes_comites, overwrite = TRUE)

