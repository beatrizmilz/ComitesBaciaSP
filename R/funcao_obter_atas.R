#' Obter tabelas sobre atas dos Comitês de Bacia
#'
#' Função para obter tabelas sobre atas dos Comitês de Bacia no Estado de São Paulo
#'
#' @param sigla_do_comite Texto referente à sigla do comitê. É possível
#' # verificar na base:  \code{\link{comites_sp}}.
#' @param online Caso seja TRUE, a tabela será obtida consultando a página web.
#' Caso seja FALSE, a tabela será obtida usando um caminho, que deve ser
#' informado no argumento \code{path_arquivo}. O valor padrão é TRUE.
#' @param path_arquivo Caminho para o arquivo .html que será lido.
#' Isso só deve ser usado com o argumento online sendo FALSE.
#' O caminho para o arquivo deve ser o gerado pela função \code{\link{download_html}}.
#' @return Retorna uma tibble. Uma base com dados coletados para todos os comitês está disponível em \code{\link{atas_comites}}.
#' @export
#'
#' @examples obter_tabela_atas_comites("at")
obter_tabela_atas_comites <- function(sigla_do_comite = NULL, online = TRUE, path_arquivo = NULL) {

  if(online == TRUE & !is.null(sigla_do_comite)){
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

    link_html <-
      ComitesBaciaSP::comites_sp %>%
      dplyr::filter(sigla_comite == sigla_do_comite) %>%
      dplyr::top_n(1, wt = n_ugrhi)  %>%
      dplyr::mutate(links = glue::glue("https://sigrh.sp.gov.br/cbh{sigla_comite}/atas")) %>%
      dplyr::pull(links)

    data_coleta_dos_dados <- Sys.Date()

  } else if(online == FALSE & !is.null(path_arquivo)) {

    nome_pagina <- path_arquivo %>%
      fs::path_file() %>%
      stringr::str_split(pattern = "-") %>%
      purrr::pluck(1) %>%
      .[2]

    if(nome_pagina != "atas"){
      stop(
        paste(
          "O caminho fornecido deve ser para o arquivo de atas"
        )
      )
    }

    link_html <- path_arquivo

    sigla_do_comite <- path_arquivo %>%
      fs::path_file() %>%
      stringr::str_split(pattern = "-") %>%
      purrr::pluck(1) %>%
      .[1]

    data_coleta_dos_dados_interm <- path_arquivo %>%
      fs::path_file() %>%
      tools::file_path_sans_ext() %>%
      stringr::str_split(pattern = "-") %>%
      purrr::pluck(1)

      data_coleta_dos_dados <-
        glue::glue("{data_coleta_dos_dados_interm[5]}-{data_coleta_dos_dados_interm[4]}-{data_coleta_dos_dados_interm[3]}") %>%
        as.character()
  } else if(online == TRUE & !is.null(path_arquivo)) {
    stop(
      paste(
        "O argumento online == TRUE não deve ser usado junto ao argumento path_arquivo, e sim
        ao argumento sigla_do_comite"
      )
    )
  }

  comite <- ComitesBaciaSP::comites_sp %>%
    dplyr::filter(sigla_comite == sigla_do_comite) %>%
    dplyr::top_n(1, wt = n_ugrhi)

  n_comite <- comite  %>% dplyr::pull(n_ugrhi)

  nome_comite <- comite %>%
    dplyr::pull(bacia_hidrografica)

  # Importante para não dar o erro do certificado SSL expirado do site
  link_get <- httr::GET(link_html, httr::config(ssl_verifypeer = FALSE))

  lista <- xml2::read_html(link_get, encoding = "UTF-8") %>%
    rvest::html_nodes("div.col_right") %>%
    rvest::html_nodes("div.block")

  url_site_coleta <-
    ComitesBaciaSP::comites_sp %>%
    dplyr::filter(sigla_comite == sigla_do_comite) %>%
    dplyr::top_n(1, wt = n_ugrhi)  %>%
    dplyr::mutate(links = glue::glue("https://sigrh.sp.gov.br/cbh{sigla_comite}/atas")) %>%
    dplyr::pull(links)




  if (length(lista) == 0) {
    df_vazia <-
      tibble::tibble(
        data_coleta_dados = data_coleta_dos_dados,
        site_coleta = url_site_coleta,
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
          stringr::str_starts(value , "/public") ~ paste0("https://sigrh.sp.gov.br", value),
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
        data_coleta_dados = data_coleta_dos_dados,
        site_coleta =  url_site_coleta,
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
