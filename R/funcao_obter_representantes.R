#' Obter tabelas sobre representantes dos Comit\u00eas de Bacia
#'
#' Fun\u00e7\u00e3o para obter tabelas sobre representantes dos Comit\u00eas de Bacia no Estado de S\u00e3o Paulo
#'
#' @param sigla_do_comite Texto referente \u00e0 sigla do comit\u00ea. \u00c9 poss\u00edvel verificar na base:  \code{\link{comites_sp}}.
#' @return Uma tibble. Uma base com dados coletados para todos os comit\u00eas est\u00e1 dispon\u00edvel em \code{\link{representantes_comites}}.
#' @export
#'
#' @examples obter_tabela_representantes_comites("smt")
obter_tabela_representantes_comites <- function(sigla_do_comite) {

  siglas_dos_comites <- ComitesBaciaSP::comites_sp %>%
    dplyr::pull(sigla_comite) %>%
    unique()

  texto_siglas_dos_comites <-   siglas_dos_comites  %>%
    paste(collapse = ", ")

  if (!sigla_do_comite %in% siglas_dos_comites) {
    stop(
      paste(
        "O texto fornecido para o argumento 'sigla_do_comite' n\u00e3o \u00e9 v\u00e1lido.
        Forne\u00e7a uma das seguintes possibilidades:",
        texto_siglas_dos_comites
      )
    )
  }

  comite_raw <- ComitesBaciaSP::comites_sp %>%
    dplyr::filter(sigla_comite == sigla_do_comite) %>%
    dplyr::top_n(1, wt = n_ugrhi)

  if (sigla_do_comite == "mp") {
    comite <- comite_raw %>%
      dplyr::mutate(
        link_representantes = glue::glue(
          "http://www.sigrh.sp.gov.br/cbh{sigla_comite}/representantes-plenario"
        )
      )

  } else if (sigla_do_comite == "pp") {
    comite <- comite_raw  %>%
      dplyr::mutate(
        link_representantes = glue::glue(
          "http://www.sigrh.sp.gov.br/cbh{sigla_comite}/representantesplenaria20192020"
        )
      )

  } else {
    comite <- comite_raw  %>%
      dplyr::mutate(
        link_representantes = glue::glue(
          "http://www.sigrh.sp.gov.br/cbh{sigla_comite}/representantes"
        )
      )

  }

  n_comite <- comite  %>% dplyr::pull(n_ugrhi)


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
        site_coleta = link_comite,
        comite = nome_comite,
        n_ugrhi = n_comite,
        organizacao_representante = NA,
        nome = NA,
        email = NA,
        cargo = NA
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
      purrr::map( ~ dplyr::filter(.x, stringr::str_detect(value, pattern = "@"))) %>%
      # purrr::map( ~ dplyr::filter(.x, value != "")) %>%
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

    # coluna com o n\u00famero do bloco
    tamanho_blocos <- 1:length(blocos)


    df <-
      tibble::tibble(
        data_coleta_dados = Sys.Date(),
        site_coleta = link_comite,
        posicao_blocos = tamanho_blocos,
        comite = nome_comite,
        n_ugrhi = n_comite,

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
      dplyr::filter(!is.na(nome)) %>%
      dplyr::select(-posicao_blocos,-ordem)


    return(df_final)
  }
}
