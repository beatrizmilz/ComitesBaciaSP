#' Title
#'
#' @param index
#'
#' @return
#' @export
#'
#' @examples
scrap_lines_by_index <- function(index) {

  date_of_scrap <- Sys.Date()

  link <- links[index]

  link_completo <- sigrh.sp::complete_url(link)

  link_status <- sigrh.sp::get_status_code(link_completo)

  link_tipo_arquivo <- sigrh.sp::get_file_format(link_completo)

  df <- tibble::tibble(
    data_scrap = date_of_scrap,
    numero_comite = n_comite,
    numero_bloco = n_block,
    ano_da_reuniao = ano_reuniao,
    nome_completo_reuniao = nome_reuniao,
    data_da_reuniao = data_reuniao,
    data_de_postagem = postado_em,

    link_ata_ordem = index,
    link_ata_url = link_completo,
    link_ata_status = link_status,
    link_ata_tipo_arquivo = link_tipo_arquivo

  )

   df_comite <<- rbind(df, df_comite)
   df_comite

}
