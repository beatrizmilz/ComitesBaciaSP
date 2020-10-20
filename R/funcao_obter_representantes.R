library(magrittr)

obter_tabela_representantes_comites <- function(n_comite) {

 # n_comite <- 5

  comite <- comites_sp %>%
    dplyr::filter(n_ugrhi == n_comite) %>%
    dplyr::mutate(
      link_representantes = glue::glue(
        "http://www.sigrh.sp.gov.br/cbh{sigla_comite}/representantes"
      )
    )

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
        nome_representantes = NA,
        email_representantes = NA,
        cargo_representantes = NA
      )

    return(df_vazia)

  } else{
    # Organizacao representante
    organizacao_representante <- blocos %>%
      purrr::map( ~  rvest::html_nodes(.x, "h2")) %>%
      purrr::map( ~ .x[1]) %>%
      purrr::map( ~ rvest::html_text(.x)) %>%
      purrr::as_vector()

    # Nome representantes
    nome_representantes <- blocos %>%
      purrr::map( ~  rvest::html_nodes(.x, "b")) %>%
      purrr::map( ~  rvest::html_text(.x, trim = TRUE)) %>%
      purrr::map( ~ tibble::as_tibble(.x)) %>%
      purrr::map(~ tibble::rowid_to_column(.x, "nome_numero")) %>%
      purrr::map(~ dplyr::mutate(.x, nome_numero = paste0("nome_", nome_numero))) %>%
      purrr::map( ~ tidyr::pivot_wider(.x, values_from = value, names_from = nome_numero)) %>%
       purrr::map( ~ tibble::as_tibble(.x)) %>%
      purrr::map( ~ if (nrow(.x) == 0) {
        .x %>% tibble::add_row()
      } else {
        .x
      }) %>%
      dplyr::bind_rows() %>%
      dplyr::select(-contains("value"))

    # Cargo representantes
    cargo_representantes <- blocos %>%
      purrr::map( ~  rvest::html_nodes(.x, "h2")) %>%
      purrr::map( ~ .x[-1]) %>%
      purrr::map( ~  rvest::html_text(.x)) %>%
      purrr::map( ~ tibble::as_tibble(.x)) %>%
      purrr::map(~ tibble::rowid_to_column(.x, "cargo_numero")) %>%
      purrr::map(~ dplyr::mutate(.x, cargo_numero = paste0("cargo_", cargo_numero))) %>%
      purrr::map( ~ tidyr::pivot_wider(.x, values_from = value, names_from = cargo_numero)) %>%
      purrr::map( ~ tibble::as_tibble(.x)) %>%
      purrr::map( ~ if (nrow(.x) == 0) {
        .x %>% tibble::add_row()
      } else {
        .x
      }) %>%
      dplyr::bind_rows() %>%
      dplyr::select(-contains("value"))



    # email representantes
    email_representantes <- blocos %>%
      purrr::map(~  rvest::html_nodes(.x, "td")) %>%
      purrr::map(~  rvest::html_text(.x, trim = TRUE)) %>%
      purrr::map(~ stringr::str_remove_all(.x, pattern = "(^| )[0-9.() -]{5,}( |$)")) %>%
      purrr::map(~ tibble::as_tibble(.x)) %>%
      purrr::map( ~ dplyr::filter(.x, value != "")) %>%
      purrr::map( ~ tibble::rowid_to_column(.x, "email_numero")) %>%
      purrr::map( ~ dplyr::mutate(.x, email_numero = paste0("email_", email_numero))) %>%
      purrr::map(~ tidyr::pivot_wider(.x, values_from = value, names_from = email_numero)) %>%
      purrr::map(~ tibble::as_tibble(.x)) %>%
      purrr::map(~ if (nrow(.x) == 0) {
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
      tidyr::pivot_wider(names_from = c(set), values_from = c(value)) %>%
    dplyr::filter(!is.na(nome))

    # %>% # erro aqui
      #tidyr::drop_na(tidyselect::all_of(c("nome", "email", "cargo")))

    return(df_final)
  }
}

# teste <- obter_tabela_representantes_comites(10)


# Comitês que não funciona: arrumar para 11 e 19, campo de email dá erro - excluir tudo que não tenha @; 17 - resulta vazio porém tem conteúdo; 20 ta esquisito o campo de email
# 20 e 21 sao os mesmos? esquisito
# 22 usa link diferente

# obter_tabela_representantes_comites(6)
