#' Função para fazer download das páginas em HTML do SigRH
#' @param sigla_do_comite Texto referente à sigla do(s) comitê(s). Pode ser informado um vetor de siglas. É possível verificar na base:  \code{\link{comites_sp}}. Por padrão, utiliza um vetor com a sigla de todos os comitês.
#' @param path O caminho onde o(s) arquivo(s) HTMl deve(m) ser baixado(s).
#' @param pagina Palavra (texto) apontando qual página deve acessada para realizar o download. Possibilidades: "representantes", "atas", "atas_agencia", "deliberacoes", "documentos", "agenda". Por padrão, utiliza um vetor com todas as possibilidades.
#'
#' @return Mensagens no console apontando o que foi baixado.
#' @export
#'
#' @examples # download_pagina_sigrh()
download_pagina_sigrh <-
  function(sigla_do_comite = ComitesBaciaSP::comites_sp$sigla_comite,
           path = here::here("html"),
           pagina = c("representantes",
                      "atas",
                      "atas_agencia",
                      "deliberacoes",
                      "documentos",
                      "agenda")) {
    fs::dir_create(path)


    url_comites <- ComitesBaciaSP::comites_sp %>%
      dplyr::mutate(
        url_atas = glue::glue("https://sigrh.sp.gov.br/cbh{sigla_comite}/atas"),
        url_representantes = glue::glue(
          "https://sigrh.sp.gov.br/cbh{sigla_comite}/representantes"
        ),
        url_deliberacoes = glue::glue("https://sigrh.sp.gov.br/cbh{sigla_comite}/deliberacoes"),
        url_documentos = glue::glue("https://sigrh.sp.gov.br/cbh{sigla_comite}/documentos"),
        url_agenda = glue::glue("https://sigrh.sp.gov.br/cbh{sigla_comite}/agenda"),
      ) %>%
      dplyr::mutate(
        url_atas_agencia =
          dplyr::case_when(sigla_comite == "at" ~ "https://sigrh.sp.gov.br/fabhat/atas")
      ) %>%
      dplyr::mutate(
        # arrumar os links que são fora do padrão
        url_representantes =
          dplyr::case_when(
            sigla_comite == "smg" ~ glue::glue("https://sigrh.sp.gov.br/cbhsmg/membros"),
            sigla_comite == "mp" ~ glue::glue("https://sigrh.sp.gov.br/cbhmp/representantes-plenario"),
            sigla_comite == "pp" ~ glue::glue(
              "https://sigrh.sp.gov.br/cbhpp/representantesplenaria20212022"
            ),
            TRUE  ~ url_representantes
          ),
        url_atas =
          dplyr::case_when(
            sigla_comite == "pp" ~ glue::glue(
              "https://sigrh.sp.gov.br/cbhpp/atasplenarias"
            ),
            TRUE  ~ url_atas
          )
      ) %>%
      dplyr::filter(sigla_comite %in% stringr::str_to_lower(sigla_do_comite))


    url_pagina <- glue::glue("url_{pagina}") %>% as.vector()
    data_hoje <- format(Sys.Date(), "%d-%m-%Y")


    for (i in 1:nrow(url_comites)) {
      sigla_comite_baixar <- url_comites %>%
        dplyr::slice(i) %>%
        dplyr::pull(sigla_comite)

      df_url <- url_comites %>%
        dplyr::slice(i) %>%
        dplyr::select(url_pagina) %>%
        tidyr::pivot_longer(cols = tidyselect::everything()) %>%
        tidyr::drop_na(value)

      for (j in 1:nrow(df_url)) {
        df_url_download <- df_url %>%
          dplyr::slice(j)

        url <- df_url_download %>%
          dplyr::pull(value)

        pagina_download <- df_url_download %>%
          dplyr::mutate(name = stringr::str_remove(name, "url_")) %>%
          dplyr::pull(name)

        caminho_salvar <-
          glue::glue("{path}/{sigla_comite_baixar}-{pagina_download}-{data_hoje}.html")


        if (fs::file_exists(caminho_salvar)) {
          usethis::ui_info(
            "Download realizado anteriormente: Arquivo referente à {pagina_download} e {sigla_comite_baixar} referente ao dia {data_hoje}."
          )
        } else {
          # Importante para não dar o erro do certificado SSL expirado do site
          url_get <-
            httr::GET(
              url,
              httr::write_disk(path = caminho_salvar, overwrite = TRUE),
              httr::config(ssl_verifypeer = FALSE)
            )

          mensagem_erro <-
            c("Pagina não encontrada", "Página não encontrada")

          mensagem_h1 <- httr::content(url_get) |>
            rvest::html_nodes("h1") |>
            rvest::html_text()

          if (mensagem_h1[1] %in% mensagem_erro) {
            usethis::ui_oops(
              "Download NÃO REALIZADO: Arquivo referente à {pagina_download} e {sigla_comite_baixar} referente ao dia {data_hoje}.
            Checar em: {url}"
            )
          } else {
            usethis::ui_done(
              "Download realizado: Arquivo referente à {pagina_download} e {sigla_comite_baixar} referente ao dia {data_hoje}."
            )
          }

        }
      }
    }
  }
