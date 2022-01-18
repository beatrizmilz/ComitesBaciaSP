#' Obter tabelas sobre representantes dos Comitês de Bacia
#'
#' Função para obter tabelas sobre representantes dos Comitês de Bacia no Estado de São Paulo
#'
#' @param sigla_do_comite Texto referente à sigla do comitê.
#' É possível verificar na base:  \code{\link{comites_sp}}.
#' @param online Caso seja TRUE, a tabela será obtida consultando a página web.
#' Caso seja FALSE, a tabela será obtida usando um caminho, que deve ser
#' informado no argumento \code{path_arquivo}. O valor padrão é TRUE.
#' @param path_arquivo Caminho para o arquivo .html que será lido.
#' Isso só deve ser usado com o argumento online sendo FALSE.
#' O caminho para o arquivo deve ser o gerado pela função \code{\link{download_html}}.
#' @return Uma tibble. Uma base com dados coletados para todos os comitês está disponível em \code{\link{representantes_comites}}.
#' @export
#'
#' @examples obter_tabela_representantes_comites("smt")
obter_tabela_representantes_comites <-
  function(sigla_do_comite = NULL,
           online = TRUE,
           path_arquivo = NULL) {
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
      comite_raw <- ComitesBaciaSP::comites_sp %>%
        dplyr::filter(sigla_comite == sigla_do_comite) %>%
        dplyr::top_n(1, wt = n_ugrhi)

      if (sigla_do_comite == "mp") {
        comite <- comite_raw %>%
          dplyr::mutate(
            link_representantes = glue::glue(
              "https://sigrh.sp.gov.br/cbh{sigla_comite}/representantes-plenario"
            )
          )

      } else if (sigla_do_comite == "pp") {
        comite <- comite_raw  %>%
          dplyr::mutate(
            link_representantes = glue::glue(
              "https://sigrh.sp.gov.br/cbh{sigla_comite}/representantesplenaria20192020"
            )
          )

      } else {
        comite <- comite_raw  %>%
          dplyr::mutate(
            link_representantes = glue::glue(
              "https://sigrh.sp.gov.br/cbh{sigla_comite}/representantes"
            )
          )

      }




      link_html <- comite  %>%
        dplyr::pull(link_representantes)

      data_coleta_dos_dados <- Sys.Date()




    } else if (online == FALSE & !is.null(path_arquivo)) {
      # aqui o caso onde usamos o arquivo

      nome_pagina <- path_arquivo %>%
        fs::path_file() %>%
        stringr::str_split(pattern = "-") %>%
        purrr::pluck(1) %>%
        .[2]

      if(nome_pagina != "representantes"){
        stop(
          paste(
            "O caminho fornecido deve ser para o arquivo de representantes"
          )
        )
      }


      link_html <- path_arquivo

      sigla_do_comite <- path_arquivo %>%
        fs::path_file() %>%
        stringr::str_split(pattern = "-") %>%
        purrr::pluck(1) %>%
        .[1]

      comite <- ComitesBaciaSP::comites_sp %>%
        dplyr::filter(sigla_comite == sigla_do_comite) %>%
        dplyr::top_n(1, wt = n_ugrhi)

      data_coleta_dos_dados_interm <- path_arquivo %>%
        fs::path_file() %>%
        tools::file_path_sans_ext() %>%
        stringr::str_split(pattern = "-") %>%
        purrr::pluck(1)

      data_coleta_dos_dados <-
        glue::glue("{data_coleta_dos_dados_interm[5]}-{data_coleta_dos_dados_interm[4]}-{data_coleta_dos_dados_interm[3]}") %>%
        as.character()


    } else if (online == TRUE & !is.null(path_arquivo)) {
      stop(
        paste(
          "O argumento online == TRUE não deve ser usado junto ao argumento path_arquivo, e sim
        ao argumento sigla_do_comite"
        )
      )
    }


    # falta colocar o setor: mesa diretora, sociedade civil, etc

    # blocos_setores <- xml2::read_html(link_html) %>%
    #   rvest::html_nodes("div.col_right") %>%
    #   rvest::html_nodes("h2.representation-header") %>%  purrr::map(~ rvest::html_text(.x, trim = TRUE))

    comite_raw <- ComitesBaciaSP::comites_sp %>%
      dplyr::filter(sigla_comite == sigla_do_comite) %>%
      dplyr::top_n(1, wt = n_ugrhi)

    nome_comite <- comite  %>% dplyr::pull(bacia_hidrografica)

    n_comite <- comite  %>% dplyr::pull(n_ugrhi)

    url_site_coleta <-
      ComitesBaciaSP::comites_sp %>%
      dplyr::filter(sigla_comite == sigla_do_comite) %>%
      dplyr::top_n(1, wt = n_ugrhi)  %>%
      dplyr::mutate(links = glue::glue("https://sigrh.sp.gov.br/cbh{sigla_comite}/atas")) %>%
      dplyr::pull(links)

# Importante para não dar o erro do certificado SSL expirado do site
    link_get <- httr::GET(link_html, httr::config(ssl_verifypeer = FALSE))

    blocos <- xml2::read_html(link_get, encoding = "UTF-8") %>%
      rvest::html_nodes("div.col_right") %>%
      rvest::html_nodes("div.block")

    if (length(blocos) == 0) {
      df_vazia <-
        tibble::tibble(
          data_coleta_dados = data_coleta_dos_dados,
          site_coleta =  url_site_coleta,
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

      # coluna com o número do bloco
      tamanho_blocos <- 1:length(blocos)


      df <-
        tibble::tibble(
          data_coleta_dados = data_coleta_dos_dados,
          site_coleta =  url_site_coleta,
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
