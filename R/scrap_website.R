#' Title
#'
#' @param n_comite
#'
#' @return
#' @export
#'
#' @examples
scrap_website <- function(n_comite) {

  n_comite <<- n_comite

  link_comite <-
    sigrh.sp::comites_sp %>%
    dplyr::filter(n_ugrhi == n_comite) %>%
    dplyr::select(links) %>%
    dplyr::pull()


  html <- xml2::read_html(link_comite)

  blocks <<- html %>%  rvest::html_nodes("div.col_right") %>%
    rvest::html_nodes("div.block")

  df_comite <<- tibble::tibble(
    data_scrap = date(),
    numero_comite = numeric(),
    numero_bloco = numeric(),
    ano_da_reuniao = numeric(),
    nome_completo_reuniao = character(),
    data_da_reuniao = date(),
    data_de_postagem = date(),
    link_ata_ordem = numeric(),
    link_ata_url = character(),
    link_ata_status = numeric(),
    link_ata_tipo_arquivo = character()

  )

  df_preenchida_final <-
    purrr::map_df(.x = (1:length(blocks)), .f = sigrh.sp::scrap_blocks)

  saveRDS(df_preenchida_final,
          file = glue::glue("dados/df_preenchida_ughri_{n_comite}.RDS"))

  beepr::beep()

  view(df_preenchida_final)
}

#------
