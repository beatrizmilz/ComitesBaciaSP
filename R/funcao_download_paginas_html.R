#' Fun\u00e7\u00e3o para fazer download das p\u00e1ginas em HTML do SigRH
#' @param siglas_comites Texto referente \u00e0 sigla do(s) comit\u00ea(s). Pode ser informado um vetor de siglas. \u00c9 poss\u00edvel verificar na base:  \code{\link{comites_sp}}. Por padr\u00e3o, utiliza um vetor com a sigla de todos os comit\u00eas.
#' @param path O caminho onde o(s) arquivo(s) HTMl deve(m) ser baixado(s).
#' @param pagina Palavra (texto) apontando qual p\u00e1gina deve acessada para realizar o download. Possibilidades: "representantes", "atas", "atas_agencia", "deliberacoes", "documentos", "agenda". Por padr\u00e3o, utiliza um vetor com todas as possibilidades.
#'
#' @return Mensagens no console apontando o que foi baixado.
#' @export
#'
#' @examples # download_html()
download_html <-
  function(siglas_comites = ComitesBaciaSP::comites_sp$sigla_comite,
           path = here::here("html"),
           pagina = c("representantes", "atas", "atas_agencia", "deliberacoes", "documentos", "agenda")) {


     fs::dir_create(path)


    url_comites <- ComitesBaciaSP::comites_sp %>%
      dplyr::mutate(
        url_atas = glue::glue("http://www.sigrh.sp.gov.br/cbh{sigla_comite}/atas"),
        url_representantes = glue::glue(
          "http://www.sigrh.sp.gov.br/cbh{sigla_comite}/representantes"
        ),
        url_deliberacoes = glue::glue(
          "http://www.sigrh.sp.gov.br/cbh{sigla_comite}/deliberacoes"
        ),
        url_documentos = glue::glue("http://www.sigrh.sp.gov.br/cbh{sigla_comite}/documentos"),
        url_agenda = glue::glue("http://www.sigrh.sp.gov.br/cbh{sigla_comite}/agenda"),
      ) %>%
      dplyr::mutate(
        url_atas_agencia =
          dplyr::case_when(
            sigla_comite == "at" ~ "http://www.sigrh.sp.gov.br/fabhat/atas"
          )
      ) %>%
      dplyr::filter(sigla_comite %in% stringr::str_to_lower(siglas_comites))


    url_pagina <- glue::glue("url_{pagina}") %>% as.vector()
    data_hoje <- format(Sys.Date(), "%d-%m-%Y")


    for (i in 1:nrow(url_comites)) {

      sigla_comite_baixar <- url_comites %>%
        dplyr::slice(i)  %>%
        dplyr::pull(sigla_comite)

      df_url <- url_comites %>%
        dplyr::slice(i)  %>%
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
          message(
            glue::glue(
              "Download realizado anteriormente: Arquivo referente \u00e0 {pagina_download} e {sigla_comite_baixar} referente ao dia {data_hoje}."
            )
          )
        } else {
          httr::GET(url, httr::write_disk(path = caminho_salvar))
          message(
            glue::glue(
              "Download realizado: Arquivo referente \u00e0 {pagina_download} e {sigla_comite_baixar} referente ao dia {data_hoje}."
            )
          )
        }


      }

    }

  }

