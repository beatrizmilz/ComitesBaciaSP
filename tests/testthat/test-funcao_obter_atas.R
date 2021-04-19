test_that("Função obter atas funciona online", {
  testthat::expect_s3_class(obter_tabela_atas_comites("at"), "data.frame")
  testthat::expect_error(obter_tabela_atas_comites("ahaha"))

})


test_that("Função obter atas funciona offline", {
  testthat::expect_s3_class(
    obter_tabela_atas_comites(online = FALSE,
                              path = "https://raw.githubusercontent.com/beatrizmilz/RelatoriosTransparenciaAguaSP/master/inst/dados_html/2021/4/alpa-atas-15-04-2021.html")
    ,
    "data.frame"
  )
  testthat::expect_error(
    obter_tabela_atas_comites(online = FALSE,
                              path = "https://raw.githubusercontent.com/beatrizmilz/RelatoriosTransparenciaAguaSP/master/inst/dados_html/2021/4/alpa-agenda-15-04-2021.html")
  )

  testthat::expect_error(
    obter_tabela_atas_comites(online = TRUE,
                              path = "https://raw.githubusercontent.com/beatrizmilz/RelatoriosTransparenciaAguaSP/master/inst/dados_html/2021/4/alpa-atas-15-04-2021.html")

  )

})
