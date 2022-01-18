#' Raspar páginas do SigRH
#'
#' Função para raspar páginas do SigRH
#'
#' @param sigla_do_comite Texto referente à sigla do comitê. É possível
#' # verificar na base:  \code{\link{comites_sp}}.
#' @param online Caso seja TRUE, a tabela será obtida consultando a página web.
#' Caso seja FALSE, a tabela será obtida usando um caminho, que deve ser
#' informado no argumento \code{path_arquivo}. O valor padrão é TRUE.
#' @param path_arquivo Caminho para o arquivo .html que será lido.
#' Isso só deve ser usado com o argumento online sendo FALSE.
#' O caminho para o arquivo deve ser o gerado pela função \code{\link{download_html}}.
#' @param conteudo_pagina Qual é o tipo de página que deve ser raspada.
#' Atualmente aceita: atas, representantes, agenda, deliberacoes, documentos.
#' @param orgao Qual é o órgão da página que deve ser raspada.
#' Atualmente aceita: cbh, agencia.
#' @return Retorna uma tibble.
#' @export
#'
#' @examples raspar_pagina_sigrh("at", conteudo_pagina = "atas", orgao = "cbh")
raspar_pagina_sigrh <-
  function(sigla_do_comite = NULL,
           conteudo_pagina = NULL,
           orgao = NULL,
           online = TRUE,
           path_arquivo = NULL) {
    # Variáveis para testar
    # sigla_do_comite <- "at"
    # orgao <- "cbh"
    # conteudo_pagina <- "deliberacoes"

    # path_arquivo <- "../RelatoriosTransparenciaAguaSP/inst/dados_html/2021/9/mp-agenda-15-09-2021.html"

    # Verificacoes se os argumentos estão válidos --------------
    print("1")
    if (online == TRUE & !is.null(path_arquivo)) {
      usethis::ui_stop(
        paste(
          "O argumento online == TRUE não deve ser usado junto ao argumento path_arquivo."
        )
      )
    }
    print("2")
    # Verificando se a sigla do comitê informada é válida
    siglas_dos_comites <- ComitesBaciaSP::comites_sp |>
      dplyr::pull(sigla_comite) |>
      unique()

    texto_siglas_dos_comites <- siglas_dos_comites |>
      paste(collapse = ", ")


    if (is.null(sigla_do_comite)) {
      usethis::ui_stop(
        paste(
          "Forneça uma das seguintes opções para o argumento 'sigla_do_comite':",
          texto_siglas_dos_comites
        )
      )
    } else if (!is.null(sigla_do_comite)) {
      if (!sigla_do_comite %in% siglas_dos_comites) {
        usethis::ui_stop(
          paste(
            "O texto fornecido para o argumento 'sigla_do_comite' não é válido.
        Forneça uma das seguintes possibilidades:",
        texto_siglas_dos_comites
          )
        )
      }
    }
    print("3")
    # verificando se forneceu o órgão
    orgaos_validos <- c("cbh", "agencia")

    texto_orgaos_validos <- orgaos_validos |>
      paste(collapse = ", ")

    if (is.null(orgao)) {
      usethis::ui_stop(
        paste(
          "Forneça uma das seguintes opções para o argumento 'orgao':",
          texto_orgaos_validos
        )
      )
    } else if (!orgao %in% orgaos_validos) {
      usethis::ui_stop(
        paste(
          "O texto fornecido para o argumento 'orgao' não é válido.
        Forneça uma das seguintes possibilidades:",
        texto_orgaos_validos
        )
      )
    }

    print("4")

    # Verificando se o tipo de página informado é válido
    paginas_validas <-
      c("atas",
        "representantes",
        "agenda",
        "deliberacoes",
        "documentos")

    texto_paginas_validas <- paginas_validas |>
      paste(collapse = ", ")

    if (is.null(conteudo_pagina)) {
      usethis::ui_stop(
        paste(
          "Forneça uma das seguintes opções para o argumento 'conteudo_pagina':",
          texto_paginas_validas
        )
      )
    } else if (!conteudo_pagina %in% paginas_validas) {
      usethis::ui_stop(
        paste(
          "O texto fornecido para o argumento 'conteudo_pagina' não é válido.
        Forneça uma das seguintes possibilidades:",
        texto_paginas_validas
        )
      )
    }

    print("5")

    # Data de hoje ------
    if (online == TRUE) {
      data_coleta_dos_dados <- Sys.Date()
    }

    # Formando o link que será usado -----------
    print("6")

    # Caso seja CBH e esteja online ---------
    if (online == TRUE & orgao == "cbh") {
      print("7")
      link_html <-
        ComitesBaciaSP::comites_sp |>
        dplyr::filter(sigla_comite == sigla_do_comite) |>
        dplyr::slice(1) |>
        dplyr::mutate(
          links = glue::glue(
            "https://sigrh.sp.gov.br/cbh{sigla_comite}/{conteudo_pagina}"
          )
        ) |>
        dplyr::pull(links)
    } else if (online == TRUE & orgao == "agencia") {
      print("8")
      # Caso seja Agencia e esteja online ----------
      # TODO:
      usethis::ui_stop("Funcionalidade futura.")
    } else if (online == FALSE &
               !is.null(path_arquivo)) {
      # Caso seja offline a partir de um arquivo ------------------
      print("9")
      nome_pagina <- path_arquivo |>
        fs::path_file() |>
        stringr::str_split(pattern = "-") |>
        purrr::pluck(1) |>
        purrr::pluck(2)

      sigla_do_comite <- path_arquivo |>
        fs::path_file() |>
        stringr::str_split(pattern = "-") |>
        purrr::pluck(1) |>
        purrr::pluck(1)

      data_coleta_dos_dados_interm <- path_arquivo |>
        fs::path_file() |>
        tools::file_path_sans_ext() |>
        stringr::str_split(pattern = "-") |>
        purrr::pluck(1)

      data_coleta_dos_dados <-
        glue::glue(
          "{data_coleta_dos_dados_interm[5]}-{data_coleta_dos_dados_interm[4]}-{data_coleta_dos_dados_interm[3]}"
        ) |>
        as.character()

      link_html <- path_arquivo
    }
    print("9")
    # buscar infos

    # Importante para não dar o erro do certificado SSL expirado do site ----
    if (online == TRUE) {
      link_get <-
        httr::GET(link_html, httr::config(ssl_verifypeer = FALSE))
    } else {
      link_get <- link_html
    }
    print("10")

    # Ler o HTML --------
    lista <- xml2::read_html(link_get, encoding = "UTF-8") |>
      rvest::html_nodes("div.col_right")

    # Se for CBH ----------
    if (orgao == "cbh") {
      print("11")
      comite <- ComitesBaciaSP::comites_sp |>
        dplyr::filter(sigla_comite == sigla_do_comite) |>
        dplyr::slice(1)

      n_comite <- comite |> dplyr::pull(n_ugrhi)

      nome_comite <- comite |>
        dplyr::pull(bacia_hidrografica)

      url_site_coleta <- ComitesBaciaSP::comites_sp |>
        dplyr::filter(sigla_comite == sigla_do_comite) |>
        dplyr::slice(1) |>
        dplyr::mutate(
          links = glue::glue(
            "https://sigrh.sp.gov.br/cbh{sigla_comite}/{conteudo_pagina}"
          )
        ) |>
        dplyr::pull(links)


      # Se for CBH/ATAS ----------
      if (conteudo_pagina == "atas") {
        print("12")
        lista <- lista |>
          rvest::html_nodes("div.block")

        if (length(lista) == 0) {
          df_vazia <-
            tibble::tibble(
              data_coleta_dados = data_coleta_dos_dados,
              site_coleta = url_site_coleta,
              orgao = orgao,
              comite = nome_comite,
              n_ugrhi = n_comite,
              nome_reuniao = NA,
              data_reuniao = NA,
              data_postagem = NA,
              url_link = NA
            )

          return(df_vazia)

        } else{
          nome_reuniao <- lista |>
            purrr::map(~  rvest::html_nodes(.x, "h2")) |>
            purrr::map(~ .x[1]) |>
            purrr::map(~ rvest::html_text(.x)) |>
            purrr::as_vector()


          lista_dados <- lista |>
            purrr::map( ~  rvest::html_nodes(.x, "ul"))

          tres_nodes <-
            lista_dados |>
            purrr::map( ~  rvest::html_nodes(.x, "li"))

          data_postagem <- tres_nodes  |>
            purrr::map(~ .x[2])  |>
            purrr::map( ~  rvest::html_text(.x)) |>
            purrr::map( ~ stringr::str_extract(.x,  "[0-9]{2}/[0-9]{2}/[0-9]{4}")) |>
            purrr::as_vector() |>
            lubridate::as_date(format = "%d/%m/%Y")


          data_reuniao <- tres_nodes  |>
            purrr::map(~ .x[1])  |>
            purrr::map( ~  rvest::html_text(.x)) |>
            purrr::map( ~ stringr::str_extract(.x,  "[0-9]{2}/[0-9]{2}/[0-9]{4}")) |>
            purrr::as_vector() |>
            lubridate::as_date(format = "%d/%m/%Y")

          link_ata <-
            tres_nodes |>
            purrr::map(~ rvest::html_nodes(.x, "a")) |>
            purrr::map(~ rvest::html_attr(.x, "href")) |>
            purrr::map(~ tibble::as_tibble(.x)) |>
            purrr::map(~ dplyr::mutate(.x, link_numero = paste0("ata_", dplyr::row_number(.x))))  |>
            purrr::map(~ dplyr::mutate(
              .x,
              value = dplyr::case_when(
                stringr::str_starts(value , "/public") ~ paste0("https://sigrh.sp.gov.br", value),
                TRUE ~ value
              )
            )) |>
            purrr::map(~ tidyr::pivot_wider(.x, values_from = value, names_from = link_numero)) |>
            purrr::map(~ tibble::as_tibble(.x)) |>
            purrr::map(~ if (nrow(.x) == 0) {
              .x |> tibble::add_row()
            } else {
              .x
            }) |>
            dplyr::bind_rows()

          df <-
            tibble::tibble(
              data_coleta_dados = data_coleta_dos_dados,
              site_coleta =  url_site_coleta,
              orgao = orgao,
              comite = nome_comite,
              n_ugrhi = n_comite,
              nome_reuniao,
              data_reuniao,
              data_postagem,
              link_ata
            )

          df_longer <- df |>
            tidyr::pivot_longer(
              tidyselect::starts_with("ata_"),
              names_to = "numero_link",
              values_to = "url_link",
              values_drop_na = TRUE
            ) |>
            dplyr::select(
              "data_coleta_dados",
              "site_coleta",
              "orgao",
              "comite" ,
              "n_ugrhi" ,
              "nome_reuniao"  ,
              "data_reuniao",
              "data_postagem"  ,
              "numero_link"   ,
              "url_link"
            )
          # |>
          #   dplyr::mutate(
          #     formato_link = dplyr::case_when(
          #       is.na(url_link) ~ "Ata não disponibilizada",
          #       TRUE ~ stringr::str_extract(url_link, pattern = "(.doc|.docx|.pdf|.html|.htm|.jpg|.pd)$|drive.google")
          #     )
          #   )


          return(df_longer)
        }

        # Se for CBH/REPRESENTANTES ----------
      } else if (conteudo_pagina == "representantes") {
        print("13")
        blocos <- lista |>
          rvest::html_nodes("div.block")

        if (length(blocos) == 0) {
          df_vazia <-
            tibble::tibble(
              data_coleta_dados = data_coleta_dos_dados,
              site_coleta = url_site_coleta,
              orgao = orgao,
              comite = nome_comite,
              n_ugrhi = n_comite,
              organizacao_representante = NA,
              nome = NA,
              email = NA,
              cargo = NA
            )

          return(df_vazia)
        } else {
          # Organizacao representante
          organizacao_representante <- blocos |>
            purrr::map( ~ rvest::html_nodes(.x, "h2")) |>
            purrr::map( ~ .x[1]) |>
            purrr::map( ~ rvest::html_text(.x)) |>
            purrr::as_vector()

          # Nome representantes
          nome_representantes <- blocos |>
            purrr::map( ~ rvest::html_nodes(.x, "b")) |>
            purrr::map( ~ rvest::html_text(.x, trim = TRUE)) |>
            purrr::map( ~ tibble::as_tibble(.x)) |>
            purrr::map( ~ tibble::rowid_to_column(.x, "nome_numero")) |>
            purrr::map( ~ dplyr::mutate(.x, nome_numero = paste0("nome_", nome_numero))) |>
            purrr::map( ~ tidyr::pivot_wider(.x, values_from = value, names_from = nome_numero)) |>
            purrr::map( ~ tibble::as_tibble(.x)) |>
            purrr::map( ~ if (nrow(.x) == 0) {
              .x |> tibble::add_row()
            } else {
              .x
            }) |>
            dplyr::bind_rows() |>
            dplyr::select(-contains("value"))

          # Cargo representantes
          cargo_representantes <- blocos |>
            purrr::map( ~ rvest::html_nodes(.x, "h2")) |>
            purrr::map( ~ .x[-1]) |>
            purrr::map( ~ rvest::html_text(.x)) |>
            purrr::map( ~ tibble::as_tibble(.x)) |>
            purrr::map( ~ tibble::rowid_to_column(.x, "cargo_numero")) |>
            purrr::map( ~ dplyr::mutate(.x, cargo_numero = paste0("cargo_", cargo_numero))) |>
            purrr::map( ~ tidyr::pivot_wider(.x, values_from = value, names_from = cargo_numero)) |>
            purrr::map( ~ tibble::as_tibble(.x)) |>
            purrr::map( ~ if (nrow(.x) == 0) {
              .x |> tibble::add_row()
            } else {
              .x
            }) |>
            dplyr::bind_rows() |>
            dplyr::select(-contains("value"))



          # email representantes
          email_representantes <- blocos |>
            purrr::map( ~ rvest::html_nodes(.x, "td")) |>
            purrr::map( ~ rvest::html_text(.x, trim = TRUE)) |>
            purrr::map( ~ stringr::str_remove_all(.x, pattern = "(^| )[0-9.() -]{5,}( |$)")) |>
            purrr::map( ~ tibble::as_tibble(.x)) |>
            purrr::map( ~ dplyr::filter(.x, stringr::str_detect(value, pattern = "@"))) |>
            # purrr::map( ~ dplyr::filter(.x, value != "")) |>
            purrr::map( ~ tibble::rowid_to_column(.x, "email_numero")) |>
            purrr::map( ~ dplyr::mutate(.x, email_numero = paste0("email_", email_numero))) |>
            purrr::map( ~ tidyr::pivot_wider(.x, values_from = value, names_from = email_numero)) |>
            purrr::map( ~ tibble::as_tibble(.x)) |>
            purrr::map( ~ if (nrow(.x) == 0) {
              .x |> tibble::add_row()
            } else {
              .x
            }) |>
            dplyr::bind_rows() |>
            dplyr::select(-contains("value"))

          # coluna com o número do bloco
          tamanho_blocos <- 1:length(blocos)


          df <-
            tibble::tibble(
              data_coleta_dados = data_coleta_dos_dados,
              site_coleta =  url_site_coleta,
              orgao = orgao,
              posicao_blocos = tamanho_blocos,
              comite = nome_comite,
              n_ugrhi = n_comite,
              organizacao_representante,
              nome_representantes,
              email_representantes,
              cargo_representantes
            )


          df_final <- df |>
            tidyr::pivot_longer(
              cols = nome_1:ncol(.),
              names_to = c("set", "ordem"),
              names_pattern = "(.+)_(.+)"
            ) |>
            tidyr::pivot_wider(names_from = c(set),
                               values_from = c(value)) |>
            dplyr::filter(!is.na(nome)) |>
            dplyr::select(-posicao_blocos,-ordem)


          return(df_final)
        }
        # Se for CBH/AGENDA ----------
      } else if (conteudo_pagina == "agenda") {
        print("14")
        if (length(lista) == 0) {
          print("15")
          df_vazia <-
            tibble::tibble(
              data_coleta_dados = data_coleta_dos_dados,
              site_coleta = url_site_coleta,
              orgao = orgao,
              comite = nome_comite,
              n_ugrhi = n_comite,
              nome_reuniao = NA,
              nome_reuniao_extra = NA,
              data_reuniao_dia = NA,
              data_reuniao_mes_ano = NA,
              link_mais_informacoes = NA
            )

          return(df_vazia)
        } else {
          print("16")
          lista_dados <-
            lista |>
            purrr::map( ~ rvest::html_nodes(.x, "div.news_event"))


          nome_reuniao <-
            lista_dados |>
            purrr::map( ~ rvest::html_nodes(.x, "h2")) |>
            purrr::pluck(1) |>
            purrr::map( ~ rvest::html_text(.x)) |>
            purrr::as_vector()


          nome_reuniao_extra <- lista_dados |>
            purrr::map( ~ rvest::html_nodes(.x, "p")) |>
            purrr::pluck(1) |>
            purrr::map( ~ rvest::html_text(.x)) |>
            purrr::map( ~ stringr::str_replace_all(.x, "[\r\t\n]", "")) |>
            purrr::map( ~ stringr::str_squish(.x)) |>
            purrr::as_vector()

          link_mais_informacoes <- lista_dados |>
            purrr::map( ~ rvest::html_node(.x, "a")) |>
            purrr::map( ~ rvest::html_attr(.x, "href")) |>
            purrr::map( ~ tibble::as_tibble(.x)) |>
            purrr::map( ~ dplyr::mutate(
              .x,
              value = dplyr::case_when(
                stringr::str_starts(value, "/collegiate") ~ paste0("https://sigrh.sp.gov.br", value),
                TRUE ~ value
              )
            )) |>
            purrr::pluck(1) |>
            purrr::as_vector()


          lista_calendar <- lista |>
            purrr::map( ~ rvest::html_nodes(.x, "div.calendar"))

          data_reuniao_mes_ano <- lista_calendar |>
            purrr::map( ~ rvest::html_node(.x, "[class='month']")) |>
            purrr::pluck(1) |>
            purrr::map( ~ rvest::html_text(.x)) |>
            purrr::map( ~ stringr::str_squish(.x)) |>
            purrr::as_vector()

          data_reuniao_dia <- lista_calendar |>
            purrr::map( ~ rvest::html_node(.x, "[class='day']")) |>
            purrr::pluck(1) |>
            purrr::map( ~ rvest::html_text(.x)) |>
            purrr::map( ~ stringr::str_squish(.x)) |>
            purrr::as_vector()

          df <-
            tibble::tibble(
              data_coleta_dados = data_coleta_dos_dados,
              site_coleta =  url_site_coleta,
              orgao = orgao,
              comite = nome_comite,
              n_ugrhi = n_comite,
              nome_reuniao,
              nome_reuniao_extra,
              data_reuniao_dia,
              data_reuniao_mes_ano,
              link_mais_informacoes
            )

          print("17")
          return(df)
        }
      } else if (conteudo_pagina == "deliberacoes") {
        # Se for CBH/DELIBERACOES ----------
        print("15")
        lista <- lista |>
          rvest::html_nodes("div.block")

        if (length(lista) == 0) {
          df_vazia <-
            tibble::tibble(
              data_coleta_dados = data_coleta_dos_dados,
              site_coleta = url_site_coleta,
              orgao = orgao,
              comite = nome_comite,
              n_ugrhi = n_comite,
              nome_deliberacao = NA,
              data_publicacao_doe = NA,
              data_documento = NA,
              data_postagem = NA,
              numero_link = NA,
              url_link = NA

            )

          return(df_vazia)

        } else{
          nome_deliberacao <- lista |>
            purrr::map(~  rvest::html_nodes(.x, "h2")) |>
            purrr::map(~ .x[1]) |>
            purrr::map(~ rvest::html_text(.x)) |>
            purrr::as_vector()

          descricao_deliberacao <- lista |>
            purrr::map(~  rvest::html_nodes(.x, "div")) |>
            purrr::map(~ .x[1]) |>
            purrr::map(~ rvest::html_text(.x,trim = TRUE)) |>
            purrr::as_vector()


          lista_dados <- lista |>
            purrr::map( ~  rvest::html_nodes(.x, "ul"))


          lista_infos <- lista_dados |> purrr::map(~ .x[1]) |>
            purrr::map( ~  rvest::html_nodes(.x, "li")) |>
            purrr::map(~ rvest::html_text(.x))

          lista_links <- lista_dados |> purrr::map(~ .x[2]) |>
            purrr::map( ~  rvest::html_nodes(.x, "li"))|>
            purrr::map( ~  rvest::html_nodes(.x, "a"))

          infos_df <- lista_infos |>
            purrr::map(~ tibble::enframe(.x)) |>
            purrr::map( ~ tidyr::separate(
              .x,
              col = value,
              into = c("desc_data", "data"),
              sep = ": "
            )) |>
            purrr::map( ~ dplyr::mutate( .x, desc_data = janitor::make_clean_names(desc_data))) |>
            purrr::map( ~ tidyr::pivot_wider( .x, names_from = "desc_data", values_from = "data")) |>
            purrr::map( ~ dplyr::select( .x, -name)) |>
            purrr::map( ~ tidyr::fill( .x, data, postado_em, .direction = "updown")) |>
            purrr::map( ~ dplyr::slice( .x, 1)) |>

          dplyr::bind_rows() |>
            dplyr::rename(
              "data_publicacao_doe" = "publicado_em_d_o_e_em",
              "data_documento" = "data",
              "data_postagem" = "postado_em" ,
            )

          link_arquivos_df <- lista_links |>
            purrr::map( ~ rvest::html_attr(.x, "href")) |>
            purrr::map( ~ tibble::as_tibble(.x)) |>
            purrr::map( ~ dplyr::mutate(.x, link_numero = paste0("documento_", dplyr::row_number(.x))))  |>
            purrr::map( ~ dplyr::mutate(
              .x,
              value = dplyr::case_when(
                stringr::str_starts(value , "/public") ~ paste0("https://sigrh.sp.gov.br", value),
                TRUE ~ value
              )
            )) |>
            purrr::map( ~ tidyr::pivot_wider(.x, values_from = value, names_from = link_numero)) |>
            purrr::map( ~ tibble::as_tibble(.x)) |>
            purrr::map( ~ if (nrow(.x) == 0) {
              .x |> tibble::add_row()
            } else {
              .x
            }) |>
            dplyr::bind_rows()


          df <-
            tibble::tibble(
              data_coleta_dados = data_coleta_dos_dados,
              site_coleta =  url_site_coleta,
              orgao = orgao,
              comite = nome_comite,
              n_ugrhi = n_comite,
              nome_deliberacao,
              infos_df,
              link_arquivos_df,
            )

          df_longer <- df |>
            tidyr::pivot_longer(
              tidyselect::starts_with("documento_"),
              names_to = "numero_link",
              values_to = "url_link",
              values_drop_na = TRUE
            ) |>
            dplyr::select(
              "data_coleta_dados",
              "site_coleta",
              "orgao",
              "comite" ,
              "n_ugrhi" ,
              "nome_deliberacao",
              "data_publicacao_doe",
              "data_documento",
              "data_postagem"  ,
              "numero_link"   ,
              "url_link"
            )


          return(df_longer)
        }
      }
    }
  }