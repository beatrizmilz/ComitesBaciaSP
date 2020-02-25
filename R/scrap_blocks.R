#' Title
#'
#' @param n_block
#'
#' @return
#' @export
#'
#' @examples
scrap_blocks <- function(n_block) {
  `%>%` <- magrittr::`%>%`

  n_block <<- n_block

  h2_nodes <-
    blocks[n_block] %>% rvest::html_nodes("h2") %>%  rvest::html_text()

  nome_reuniao <<- h2_nodes[1]

  ul_li_nodes <-
    blocks[n_block] %>%
    rvest::html_nodes("ul") %>%
    rvest::html_nodes("li") %>%
    rvest::html_text() %>%
    stringr::str_extract("\\d{2}/\\d{2}/\\d{4}") %>%
    stringr::str_trim()

  anos <<- ul_li_nodes  %>%
    stringr::str_extract("\\d{4}")

  ano_reuniao <<- as.numeric(anos[1])

  data_reuniao <<-  lubridate::dmy(ul_li_nodes[1])

  postado_em <<- lubridate::dmy(ul_li_nodes[2])

  links <<-
    blocks[n_block] %>% rvest::html_nodes("ul") %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")

  df_preenchida <-
    purrr::map_df(.x = (1:length(links)),
           .f = sigrh.sp::scrap_lines_by_index)


}
