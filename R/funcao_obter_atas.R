#' Obter tabelas sobre atas dos Comitês de Bacia
#'
#' Função para obter tabelas sobre atas dos Comitês de Bacia no Estado de São Paulo
#'
#' @param sigla_do_comite Texto referente à sigla do comitê. É possível verificar na base:  \code{\link{comites_sp}}.
#' @return Retorna uma tibble. Uma base com dados coletados para todos os comitês está disponível em \code{\link{atas_comites}}.
#' @export
#'
#' @examples obter_tabela_atas_comites("at")
obter_tabela_atas_comites <- function(sigla_do_comite) {
  siglas_dos_comites <- ComitesBaciaSP::comites_sp %>%
    dplyr::pull(sigla_comite) %>%
    unique()

  texto_siglas_dos_comites <-   siglas_dos_comites  %>%
    paste(collapse = ", ")

  if (!sigla_do_comite %in% siglas_dos_comites) {
    stop(
      paste(
        "O texto fornecido para o argumento 'sigla_do_comite' não é válido.
        Forneça uma das seguintes possibilidades:",
        texto_siglas_dos_comites
      )
    )
  }


  comite <- ComitesBaciaSP::comites_sp %>%
    dplyr::filter(sigla_comite == sigla_do_comite) %>%
    dplyr::top_n(1, wt = n_ugrhi)

  n_comite <- comite  %>% dplyr::pull(n_ugrhi)

  link_comite <-
    comite  %>%
    dplyr::mutate(links = glue::glue("http://www.sigrh.sp.gov.br/cbh{sigla_comite}/atas")) %>%
    dplyr::pull(links)

  nome_comite <- comite %>%
    dplyr::pull(bacia_hidrografica)


  lista <- xml2::read_html(link_comite) %>%
    rvest::html_nodes("div.col_right") %>%
    rvest::html_nodes("div.block")


  if (length(lista) == 0) {
    df_vazia <-
      tibble::tibble(
        data_coleta_dados = Sys.Date(),
        site_coleta = link_comite,
        comite = nome_comite,
        n_ugrhi = n_comite,
        nome_reuniao = NA,
        data_reuniao = NA,
        data_postagem = NA,
        url_link = NA
      )

    return(df_vazia)

  } else{
    nome_reuniao <- lista %>%
      purrr::map(~  rvest::html_nodes(.x, "h2")) %>%
      purrr::map(~ .x[1]) %>%
      purrr::map(~ rvest::html_text(.x)) %>%
      purrr::as_vector()


    lista_dados <- lista %>%
      purrr::map( ~  rvest::html_nodes(.x, "ul"))

    tres_nodes <-
      lista_dados %>%
      purrr::map( ~  rvest::html_nodes(.x, "li"))

    data_postagem <- tres_nodes  %>%
      purrr::map(~ .x[2])  %>%
      purrr::map( ~  rvest::html_text(.x)) %>%
      purrr::map( ~ stringr::str_extract(.x,  "[0-9]{2}/[0-9]{2}/[0-9]{4}")) %>%
      purrr::as_vector() %>%
      lubridate::as_date(format = "%d/%m/%Y")


    data_reuniao <- tres_nodes  %>%
      purrr::map(~ .x[1])  %>%
      purrr::map( ~  rvest::html_text(.x)) %>%
      purrr::map( ~ stringr::str_extract(.x,  "[0-9]{2}/[0-9]{2}/[0-9]{4}")) %>%
      purrr::as_vector() %>%
      lubridate::as_date(format = "%d/%m/%Y")

    link_ata <-
      tres_nodes %>%
      purrr::map(~ rvest::html_nodes(.x, "a")) %>%
      purrr::map(~ rvest::html_attr(.x, "href")) %>%
      purrr::map(~ tibble::as_tibble(.x)) %>%
      purrr::map(~ dplyr::mutate(.x, link_numero = paste0("ata_", dplyr::row_number(.x))))  %>%
      purrr::map(~ dplyr::mutate(
        .x,
        value = dplyr::case_when(
          stringr::str_starts(value , "/public") ~ paste0("http://www.sigrh.sp.gov.br", value),
          TRUE ~ value
        )
      )) %>%
      purrr::map(~ tidyr::pivot_wider(.x, values_from = value, names_from = link_numero)) %>%
      purrr::map(~ tibble::as_tibble(.x)) %>%
      purrr::map(~ if (nrow(.x) == 0) {
        .x %>% tibble::add_row()
      } else {
        .x
      }) %>%
      dplyr::bind_rows()

    df <-
      tibble::tibble(
        data_coleta_dados = Sys.Date(),
        site_coleta = link_comite,
        comite = nome_comite,
        n_ugrhi = n_comite,
        nome_reuniao,
        data_reuniao,
        data_postagem,
        link_ata
      )

    df_longer <- df %>%
      tidyr::pivot_longer(
        tidyselect::starts_with("ata_"),
        names_to = "numero_link",
        values_to = "url_link",
        values_drop_na = TRUE
      ) %>%
      dplyr::select(
        "data_coleta_dados",
        "site_coleta",
        "comite" ,
        "n_ugrhi" ,
        "nome_reuniao"  ,
        "data_reuniao",
        "data_postagem"  ,
        "numero_link"   ,
        "url_link"
      )
    # %>%
    #   dplyr::mutate(
    #     formato_link = dplyr::case_when(
    #       is.na(url_link) ~ "Ata não disponibilizada",
    #       TRUE ~ stringr::str_extract(url_link, pattern = "(.doc|.docx|.pdf|.html|.htm|.jpg|.pd)$|drive.google")
    #     )
    #   )


    return(df_longer)
  }

}
