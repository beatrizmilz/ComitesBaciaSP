test_that("Função de download das páginas funciona", {
  testthat::expect_error(download_html(sigla_do_comite = "ahahaha"))
  testthat::expect_error(download_html(pagina = "naoexiste"))
  testthat::expect_message(download_html(sigla_do_comite = "at"))
})


