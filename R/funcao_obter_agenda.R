#' Obter tabelas sobre agenda dos Comitês de Bacia
#'
#' Função para obter tabelas sobre agenda dos Comitês de Bacia no Estado de São Paulo
#'
#' @param sigla_do_comite Texto referente à sigla do comitê. É possível
#' # verificar na base:  \code{\link{comites_sp}}.
#' @param online Caso seja TRUE, a tabela será obtida consultando a página web.
#' Caso seja FALSE, a tabela será obtida usando um caminho, que deve ser
#' informado no argumento \code{path_arquivo}. O valor padrão é TRUE.
#' @param path_arquivo Caminho para o arquivo .html que será lido.
#' Isso só deve ser usado com o argumento online sendo FALSE.
#' O caminho para o arquivo deve ser o gerado pela função \code{\link{download_html}}.
#' @return Retorna uma tibble.
#' @export
#'
#' @examples obter_tabela_agenda_comites("at")
obter_tabela_agenda_comites <-
  function(sigla_do_comite = NULL,
           online = TRUE,
           path_arquivo = NULL) {
    # sigla_do_comite <- "mp"
    # path_arquivo <- "../RelatoriosTransparenciaAguaSP/inst/dados_html/2021/9/mp-agenda-15-09-2021.html"

    if (online == TRUE & !is.null(sigla_do_comite)) {
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
        dplyr::mutate(links = glue::glue("https://sigrh.sp.gov.br/cbh{sigla_comite}/agenda")) %>%
        dplyr::pull(links)

      data_coleta_dos_dados <- Sys.Date()

    } else if (online == FALSE & !is.null(path_arquivo)) {
      nome_pagina <- path_arquivo %>%
        fs::path_file() %>%
        stringr::str_split(pattern = "-") %>%
        purrr::pluck(1) %>%
        .[2]

      if (nome_pagina != "agenda") {
        stop(paste("O caminho fornecido deve ser para o arquivo de agenda."))
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
        glue::glue(
          "{data_coleta_dos_dados_interm[5]}-{data_coleta_dos_dados_interm[4]}-{data_coleta_dos_dados_interm[3]}"
        ) %>%
        as.character()
    } else if (online == TRUE & !is.null(path_arquivo)) {
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

    lista <- xml2::read_html(link_html, encoding = "UTF-8") %>%
      rvest::html_nodes("div.col_right")

    url_site_coleta <-
      ComitesBaciaSP::comites_sp %>%
      dplyr::filter(sigla_comite == sigla_do_comite) %>%
      dplyr::top_n(1, wt = n_ugrhi)  %>%
      dplyr::mutate(links = glue::glue("https://sigrh.sp.gov.br/cbh{sigla_comite}/agenda")) %>%
      dplyr::pull(links)




    if (length(lista) == 0) {
      df_vazia <-
        tibble::tibble(
          data_coleta_dados = data_coleta_dos_dados,
          site_coleta = url_site_coleta,
          comite = nome_comite,
          n_ugrhi = n_comite,
          nome_reuniao = NA,
          nome_reuniao_extra = NA,
          data_reuniao_dia = NA,
          data_reuniao_mes_ano = NA,
          link_mais_informacoes = NA,
          data_reuniao = NA
        )

      return(df_vazia)

    } else{
      lista_dados <-
        lista %>%
        purrr::map( ~ rvest::html_nodes(.x, "div.news_event"))


      nome_reuniao <-
        lista_dados |>
        purrr::map( ~  rvest::html_nodes(.x, "h2")) %>%
        purrr::pluck(1) |>
        purrr::map( ~ rvest::html_text(.x)) %>%
        purrr::as_vector()


      nome_reuniao_extra <- lista_dados %>%
        purrr::map( ~  rvest::html_nodes(.x, "p")) %>%
        purrr::pluck(1) |>
        purrr::map( ~ rvest::html_text(.x)) %>%
        purrr::map( ~  stringr::str_replace_all(.x, "[\r\t\n]", "")) %>%
        purrr::map( ~ stringr::str_squish(.x)) %>%
        purrr::as_vector()

      link_mais_informacoes <- lista_dados %>%
        purrr::map( ~ rvest::html_node(.x, "a")) %>%
        purrr::map( ~ rvest::html_attr(.x, "href")) %>%
        purrr::map( ~ tibble::as_tibble(.x)) %>%
        purrr::map( ~ dplyr::mutate(
          .x,
          value = dplyr::case_when(
            stringr::str_starts(value , "/collegiate") ~ paste0("https://sigrh.sp.gov.br", value),
            TRUE ~ value
          )
        )) %>%
        purrr::pluck(1) |>
        purrr::as_vector()


      lista_calendar <- lista %>%
        purrr::map( ~  rvest::html_nodes(.x, "div.calendar"))

      data_reuniao_mes_ano <- lista_calendar %>%
        purrr::map( ~  rvest::html_node(.x, "[class='month']")) %>%
        purrr::pluck(1) |>
        purrr::map( ~ rvest::html_text(.x)) %>%
        purrr::map( ~ stringr::str_squish(.x)) %>%
        purrr::as_vector()

      data_reuniao_dia <- lista_calendar %>%
        purrr::map( ~  rvest::html_node(.x, "[class='day']")) %>%
        purrr::pluck(1) |>
        purrr::map( ~ rvest::html_text(.x)) %>%
        purrr::map( ~ stringr::str_squish(.x)) %>%
        purrr::as_vector()

      df <-
        tibble::tibble(
          data_coleta_dados = data_coleta_dos_dados,
          site_coleta =  url_site_coleta,
          comite = nome_comite,
          n_ugrhi = n_comite,
          nome_reuniao,
          nome_reuniao_extra,
          data_reuniao_dia,
          data_reuniao_mes_ano,
          link_mais_informacoes
        )


      df_2 <- df |>
        tidyr::separate(
          data_reuniao_mes_ano,
          c("data_reuniao_mes", "data_reuniao_ano"),
          sep = "/",
          remove = FALSE
        ) |>
        dplyr::mutate(
          data_reuniao_ano = stringr::str_trim(data_reuniao_ano),
          data_reuniao_mes = stringr::str_trim(data_reuniao_mes),

          data_reuniao_ano =  dplyr::case_when(
            as.numeric(data_reuniao_ano) >= 0 &
              as.numeric(data_reuniao_ano) < 80 ~ paste0("20", stringr::str_trim(data_reuniao_ano)),
            TRUE ~ paste0("19", stringr::str_trim(data_reuniao_ano)),
          ),
          data_reuniao_mes =  dplyr::case_when(
            data_reuniao_mes == "JAN" ~ 1,
            data_reuniao_mes == "FEV" ~ 2,
            data_reuniao_mes == "MAR" ~ 3,
            data_reuniao_mes == "ABR" ~ 4,
            data_reuniao_mes == "MAI" ~ 5,
            data_reuniao_mes == "JUN" ~ 6,
            data_reuniao_mes == "JUL" ~ 7,
            data_reuniao_mes == "AGO" ~ 8,
            data_reuniao_mes == "SET" ~ 9,
            data_reuniao_mes == "OUT" ~ 10,
            data_reuniao_mes == "NOV" ~ 11,
            data_reuniao_mes == "DEZ" ~ 12

          ),
          data_reuniao = lubridate::as_date(
            paste0(
              data_reuniao_ano,
              "-",
              data_reuniao_mes,
              "-",
              data_reuniao_dia
            )
          )
        ) |>
        dplyr::select(-data_reuniao_mes,-data_reuniao_ano)


      return(df_2)
    }

  }
