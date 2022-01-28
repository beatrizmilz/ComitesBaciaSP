test_that("Função de download das páginas funciona", {
  testthat::expect_error(download_pagina_sigrh(sigla_do_comite = "ahahaha"))
  testthat::expect_error(download_pagina_sigrh(pagina = "naoexiste"))
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "at"), "Download realizado:")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "mp"), "Download realizado:")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "smg"), "Download realizado:")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "pp"), "Download realizado:")

  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "pp", pagina = "atas"), "Download realizado:")
})


