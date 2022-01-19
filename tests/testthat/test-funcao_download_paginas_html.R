test_that("Função de download das páginas funciona", {
  testthat::expect_error(download_pagina_sigrh(sigla_do_comite = "ahahaha"))
  testthat::expect_error(download_pagina_sigrh(pagina = "naoexiste"))
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "at"))
})


