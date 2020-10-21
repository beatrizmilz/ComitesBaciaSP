municipios_sp <-
  xml2::read_html("http://www.sigrh.sp.gov.br/municipios") %>%
  rvest::html_table(header = TRUE) %>%
  .[[3]] %>%
  janitor::clean_names()


comites_sp <- municipios_sp %>%
  dplyr::mutate(
    n_ugrhi = stringr::str_extract(ugrhi,  "[0-9]{2}"),
    sigla_comite = stringr::str_remove(cbh, "CBH-"),
    sigla_comite = stringr::str_to_lower(sigla_comite),
    n_ugrhi = dplyr::case_when(sigla_comite == "ps" ~ 02,
                               sigla_comite == "tj" ~ 13,
                               TRUE ~ as.double(n_ugrhi)),
    links = glue::glue("http://www.sigrh.sp.gov.br/cbh{sigla_comite}/atas")
  ) %>%

  dplyr::group_by(bacia_hidrografica, sigla_comite, n_ugrhi, links) %>%
  dplyr::count() %>%
  dplyr::arrange(n_ugrhi) %>%
  dplyr::mutate(macrometropole_daee = dplyr::case_when(
    sigla_comite %in% c("ps","ln","pcj","at","bs","mogi","smt","rb") ~ TRUE,
    TRUE ~ FALSE
  )) # %>%
  # dplyr::mutate(
  #   links_funcionando = purrr::map_dbl(links, purrr::possibly(
  #     ~ httr::status_code(httr::GET(.x)), otherwise = NA
  #   ))
  # )


# usethis::use_data(comites_sp, overwrite = TRUE)

