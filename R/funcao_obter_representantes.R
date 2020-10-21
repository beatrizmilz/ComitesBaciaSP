#' Obter tabelas sobre representantes dos Comitês de Bacia
#'
#' Função para obter tabelas sobre representantes dos Comitês de Bacia no Estado de São Paulo
#'
#' @param n_comite Número referente ao comitê. É possível verificar na base:  \code{\link{comites_sp}}.
#'
#' @return Uma tibble.
#' @export
#'
#' @examples obter_tabela_representantes_comites(10)
obter_tabela_representantes_comites <- function(n_comite) {


  if (n_comite == 17) {
    comite <- comites_sp %>%
      dplyr::filter(n_ugrhi == n_comite) %>%
      dplyr::mutate(
        link_representantes = glue::glue(
          "http://www.sigrh.sp.gov.br/cbh{sigla_comite}/representantes-plenario"
        )
      )

  } else if (n_comite == 22) {
    comite <- comites_sp %>%
      dplyr::filter(n_ugrhi == n_comite) %>%
      dplyr::mutate(
        link_representantes = glue::glue(
          "http://www.sigrh.sp.gov.br/cbh{sigla_comite}/representantesplenaria20192020"
        )
      )

  } else {
    comite <- comites_sp %>%
      dplyr::filter(n_ugrhi == n_comite) %>%
      dplyr::mutate(
        link_representantes = glue::glue(
          "http://www.sigrh.sp.gov.br/cbh{sigla_comite}/representantes"
        )
      )

  }



  link_comite <- comite  %>%
    dplyr::pull(link_representantes)

  nome_comite <- comite %>%
    dplyr::pull(bacia_hidrografica)

  # falta colocar o setor: mesa diretora, sociedade civil, etc

  # blocos_setores <- xml2::read_html(link_comite) %>%
  #   rvest::html_nodes("div.col_right") %>%
  #   rvest::html_nodes("h2.representation-header") %>%  purrr::map(~ rvest::html_text(.x, trim = TRUE))


  blocos <- xml2::read_html(link_comite) %>%
    rvest::html_nodes("div.col_right") %>%
    rvest::html_nodes("div.block")

  if (length(blocos) == 0) {
    df_vazia <-
      tibble::tibble(
        data_coleta_dados = Sys.Date(),
        comite = nome_comite,
        comite_numero = n_comite,
        site_coleta = link_comite,
        organizacao_representante = NA,
        nome = NA,
        email = NA,
        cargo = NA
      )

    return(df_vazia)

  } else{
    # Organizacao representante
    organizacao_representante <- blocos %>%
      purrr::map(~  rvest::html_nodes(.x, "h2")) %>%
      purrr::map(~ .x[1]) %>%
      purrr::map(~ rvest::html_text(.x)) %>%
      purrr::as_vector()

    # Nome representantes
    nome_representantes <- blocos %>%
      purrr::map(~  rvest::html_nodes(.x, "b")) %>%
      purrr::map(~  rvest::html_text(.x, trim = TRUE)) %>%
      purrr::map(~ tibble::as_tibble(.x)) %>%
      purrr::map( ~ tibble::rowid_to_column(.x, "nome_numero")) %>%
      purrr::map( ~ dplyr::mutate(.x, nome_numero = paste0("nome_", nome_numero))) %>%
      purrr::map(~ tidyr::pivot_wider(.x, values_from = value, names_from = nome_numero)) %>%
      purrr::map(~ tibble::as_tibble(.x)) %>%
      purrr::map(~ if (nrow(.x) == 0) {
        .x %>% tibble::add_row()
      } else {
        .x
      }) %>%
      dplyr::bind_rows() %>%
      dplyr::select(-contains("value"))

    # Cargo representantes
    cargo_representantes <- blocos %>%
      purrr::map(~  rvest::html_nodes(.x, "h2")) %>%
      purrr::map(~ .x[-1]) %>%
      purrr::map(~  rvest::html_text(.x)) %>%
      purrr::map(~ tibble::as_tibble(.x)) %>%
      purrr::map( ~ tibble::rowid_to_column(.x, "cargo_numero")) %>%
      purrr::map( ~ dplyr::mutate(.x, cargo_numero = paste0("cargo_", cargo_numero))) %>%
      purrr::map(~ tidyr::pivot_wider(.x, values_from = value, names_from = cargo_numero)) %>%
      purrr::map(~ tibble::as_tibble(.x)) %>%
      purrr::map(~ if (nrow(.x) == 0) {
        .x %>% tibble::add_row()
      } else {
        .x
      }) %>%
      dplyr::bind_rows() %>%
      dplyr::select(-contains("value"))



    # email representantes
    email_representantes <- blocos %>%
      purrr::map( ~  rvest::html_nodes(.x, "td")) %>%
      purrr::map( ~  rvest::html_text(.x, trim = TRUE)) %>%
      purrr::map( ~ stringr::str_remove_all(.x, pattern = "(^| )[0-9.() -]{5,}( |$)")) %>%
      purrr::map( ~ tibble::as_tibble(.x)) %>%
      purrr::map(~ dplyr::filter(.x, stringr::str_detect(value, pattern = "@"))) %>%
      # purrr::map( ~ dplyr::filter(.x, value != "")) %>%
      purrr::map(~ tibble::rowid_to_column(.x, "email_numero")) %>%
      purrr::map(~ dplyr::mutate(.x, email_numero = paste0("email_", email_numero))) %>%
      purrr::map( ~ tidyr::pivot_wider(.x, values_from = value, names_from = email_numero)) %>%
      purrr::map( ~ tibble::as_tibble(.x)) %>%
      purrr::map( ~ if (nrow(.x) == 0) {
        .x %>% tibble::add_row()
      } else {
        .x
      }) %>%
      dplyr::bind_rows() %>%
      dplyr::select(-contains("value"))

    # coluna com o número do bloco
    tamanho_blocos <- 1:length(blocos)


    df <-
      tibble::tibble(
        data_coleta_dados = Sys.Date(),
        posicao_blocos = tamanho_blocos,
        comite = nome_comite,
        comite_numero = n_comite,
        site_coleta = link_comite,
        organizacao_representante,
        nome_representantes,
        email_representantes,
        cargo_representantes
      )


    df_final <- df %>% tidyr::pivot_longer(
      cols = nome_1:ncol(.),
      names_to = c("set", "ordem"),
      names_pattern = "(.+)_(.+)"
    )    %>%
      tidyr::pivot_wider(names_from = c(set),
                         values_from = c(value)) %>%
      dplyr::filter(!is.na(nome))


    return(df_final)
  }
}


#SALVAR OS DADOS NO PACOTE -----------------
# numeros_dos_comites <- comites_sp %>%
#   dplyr::filter(n_ugrhi != 21) %>% # As UGRHIs 21 e 20 tem o mesmo comitê
#   dplyr::pull(n_ugrhi)
# #
# representantes_comites <-
#   purrr::map_df(numeros_dos_comites, obter_tabela_representantes_comites)
#
# representantes_comites %>%
#   write.csv2(
#     file = glue::glue(
#       "inst/extdata/tabela_representantes_comites_{Sys.Date()}.csv"
#     ),
#     fileEncoding = "UTF-8"
#   )
#
# usethis::use_data(representantes_comites, overwrite = TRUE)
