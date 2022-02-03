test_that("Função de download das páginas funciona", {
  testthat::expect_error(download_pagina_sigrh(sigla_do_comite = "ahahaha"))
  testthat::expect_error(download_pagina_sigrh(pagina = "naoexiste"))
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "at"), "Download realizado")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "mp"), "Download realizado")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "smg"), "Download realizado")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "pp", pagina = "representantes"), "Download realizado")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "pp", pagina = "atas"), "Download realizado")



  # CRH -------
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "crh", pagina = "atas"), "Download realizado")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "crh", pagina = "representantes"), "Download realizado")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "crh", pagina = "documentos"), "Download realizado")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "crh", pagina = "deliberacoes"), "Download realizado")
  testthat::expect_message(download_pagina_sigrh(sigla_do_comite = "crh", pagina = "agenda"), "Download realizado")
})


