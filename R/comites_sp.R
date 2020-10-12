library(magrittr)

ugrhis <- tibble::tibble(
  nome_ugrhi = "Paraíba do Sul",
  n_ugrhi = 2,
  sigla_comite = "ps",
  pertence_mmp_daee = TRUE,
) %>%
  tibble::add_row(
    nome_ugrhi = "Litoral Norte",
    n_ugrhi = 3,
    sigla_comite = "ln",
    pertence_mmp_daee = TRUE,
) %>%
  tibble::add_row(
    nome_ugrhi = "Piracicaba/Capivari/Jundiaí",
    n_ugrhi = 5,
    sigla_comite = "pcj",
    pertence_mmp_daee = TRUE,
  ) %>%
  tibble::add_row(
    nome_ugrhi = "Alto Tietê",
    n_ugrhi = 6,
    sigla_comite = "at",
    pertence_mmp_daee = TRUE,
  )%>%
  tibble::add_row(
    nome_ugrhi = "Baixada Santista",
    n_ugrhi = 7,
    sigla_comite = "bs",
    pertence_mmp_daee = TRUE,
  )%>%
  tibble::add_row(
    nome_ugrhi = "Mogi-Guaçu",
    n_ugrhi = 9,
    sigla_comite = "mogi",
    pertence_mmp_daee = TRUE,
  )%>%
  tibble::add_row(
    nome_ugrhi = "Tietê/Sorocaba",
    n_ugrhi = 10,
    sigla_comite = "smt",
    pertence_mmp_daee = TRUE,
  )%>%
  tibble::add_row(
    nome_ugrhi = "Ribeira de Iguape/Litoral Sul",
    n_ugrhi = 11,
    sigla_comite = "rb",
    pertence_mmp_daee = TRUE,
  )

# ADICIONAR TODOS OS COMITÊS AQUI


comites_sp <- ugrhis %>%
  dplyr::mutate(
    links = glue::glue("http://www.sigrh.sp.gov.br/cbh{ugrhis$sigla_comite}/atas"),
    links_funcionando = purrr::map_dbl(links, purrr::possibly(
      ~ httr::status_code(httr::GET(.x)), otherwise = NA
    )))


usethis::use_data(comites_sp, overwrite = TRUE)
