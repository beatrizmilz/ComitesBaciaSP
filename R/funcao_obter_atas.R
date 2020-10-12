#' Função para obter tabelas de atas dos comitês
#'
#' @param n_comite
#'
#' @return Retorna uma tibble.
#' @export
#'
#' @examples obter_tabela_atas_comites(3)
obter_tabela_atas_comites <- function(n_comite) {
  comite <- comites_sp %>%
    dplyr::filter(n_ugrhi == n_comite)

  link_comite <-
    comite  %>%
    dplyr::select(links) %>%
    dplyr::pull()

  nome_comite <- comite %>%
    dplyr::select(nome_ugrhi) %>%
    dplyr::pull()


  lista <- xml2::read_html(link_comite) %>%
    rvest::html_nodes("div.col_right") %>%
    rvest::html_nodes("div.block")


  if (length(lista) == 0) {
    df_vazia <-
      tibble::tibble(
        data_coleta_dados = Sys.Date(),
        comite = nome_comite,
        comite_numero = n_comite,
        nome_reuniao = NA,
        data_reuniao = NA,
        data_postagem = NA,
        url_link = NA
      )

    return(df_vazia)

  } else{
    nome_reuniao <- lista %>%
      purrr::map( ~  rvest::html_nodes(.x, "h2")) %>%
      purrr::map( ~ .x[1]) %>%
      purrr::map( ~ rvest::html_text(.x)) %>%
      purrr::as_vector()


    lista_dados <- lista %>%
      purrr::map(~  rvest::html_nodes(.x, "ul"))

    tres_nodes <-
      lista_dados %>%
      purrr::map(~  rvest::html_nodes(.x, "li"))

    data_postagem <- tres_nodes  %>%
      purrr::map( ~ .x[2])  %>%
      purrr::map(~  rvest::html_text(.x)) %>%
      purrr::map(~ stringr::str_extract(.x,  "[0-9]{2}/[0-9]{2}/[0-9]{4}")) %>%
      purrr::as_vector() %>%
      lubridate::as_date(format = "%d/%m/%Y")


    data_reuniao <- tres_nodes  %>%
      purrr::map( ~ .x[1])  %>%
      purrr::map(~  rvest::html_text(.x)) %>%
      purrr::map(~ stringr::str_extract(.x,  "[0-9]{2}/[0-9]{2}/[0-9]{4}")) %>%
      purrr::as_vector() %>%
      lubridate::as_date(format = "%d/%m/%Y")

    link_ata <-
      tres_nodes %>%
      purrr::map( ~ rvest::html_nodes(.x, "a")) %>%
      purrr::map( ~ rvest::html_attr(.x, "href")) %>%
      purrr::map( ~ tibble::as_tibble(.x)) %>%
      purrr::map( ~ dplyr::mutate(.x, link_numero = paste0("ata_", dplyr::row_number(.x))))  %>%
      purrr::map( ~ dplyr::mutate(
        .x,
        value = dplyr::case_when(
          stringr::str_starts(value , "/public") ~ paste0("http://www.sigrh.sp.gov.br", value),
          TRUE ~ value
        )
      )) %>%
      purrr::map( ~ tidyr::pivot_wider(.x, values_from = value, names_from = link_numero)) %>%
      purrr::map( ~ tibble::as_tibble(.x)) %>%
      purrr::map( ~ if (nrow(.x) == 0) {
        .x %>% tibble::add_row()
      } else {
        .x
      }) %>%
      dplyr::bind_rows()

    df <-
      tibble::tibble(
        data_coleta_dados = Sys.Date(),
        comite = nome_comite,
        comite_numero = n_comite,
        nome_reuniao,
        data_reuniao,
        data_postagem,
        link_ata
      )

    df_longer <- df %>%
      tidyr::pivot_longer(
        starts_with("ata_"),
        names_to = "numero_link",
        values_to = "url_link",
        values_drop_na = TRUE
      ) %>%
      dplyr::select(
        "data_coleta_dados",
        "comite" ,
        "comite_numero" ,
        "nome_reuniao"  ,
        "data_reuniao",
        "data_postagem"  ,
        "numero_link"   ,
        "url_link"
      ) %>%
      dplyr::mutate(
        formato_link = dplyr::case_when(
          is.na(url_link) ~ "Ata não disponibilizada",
          TRUE ~ stringr::str_extract(url_link, pattern = "(.doc|.docx|.pdf|.html|.htm|.jpg|.pd)$|drive.google")
        )
      )


    return(df_longer)
  }

}

# View(obter_tabela_atas_comites(3))

#SALVAR OS DADOS NO PACOTE -----------------
numeros_dos_comites <- comites_sp %>% dplyr::pull(n_ugrhi)

tabela_atas_comites <-
  purrr::map_df(numeros_dos_comites, obter_tabela_atas_comites)

tabela_atas_comites %>% write.csv2(file = glue::glue("inst/extdata/tabela_atas_comites_{Sys.Date()}.csv"), fileEncoding = "UTF-8")

usethis::use_data(tabela_atas_comites, overwrite = TRUE)
