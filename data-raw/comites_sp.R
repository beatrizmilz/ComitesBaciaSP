## code to prepare `DATASET` dataset goes here

comites <- structure(
  list(
    ugrhi = c(
      "02 - Paraíba do Sul",
      "03 - Litoral Norte",
      "05 - Piracicaba/Capivari/Jundiaí",
      "06 - Alto Tietê",
      "07 - Baixada Santista",
      "09 - Mogi-Guaçu",
      "10 - Tietê/Sorocaba",
      "11 - Ribeira de Iguape/Litoral Sul"
    ),
    n_ugrhi = c(2, 3,
                5, 6, 7, 9, 10, 11),
    nome_ugrhi = c(
      " Paraíba do Sul",
      " Litoral Norte",
      " Piracicaba/Capivari/Jundiaí",
      " Alto Tietê",
      " Baixada Santista",
      " Mogi-Guaçu",
      " Tietê/Sorocaba",
      " Ribeira de Iguape/Litoral Sul"
    ),

    siglas_comites = c("ps", "ln", "pcj", "at", "bs", "mogi", "smt", "rb")
  ),
  class = c("tbl_df", "tbl",
            "data.frame"),
  row.names = c(NA, -8L)
)

comites <-
  tibble::add_column(comites, mmp = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE))


links <-
  paste0("http://www.sigrh.sp.gov.br/cbh",
         comites$siglas_comites ,
         "/atas")

comites_sp <- tibble::add_column(comites, links)

usethis::use_data(comites_sp)
