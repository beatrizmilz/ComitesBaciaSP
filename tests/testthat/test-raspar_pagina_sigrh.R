test_that("raspar_pagina_sigrh() works", {

  testthat::expect_error(raspar_pagina_sigrh(sigla_do_comite = "at"))

  agenda_cbhat <- raspar_pagina_sigrh(sigla_do_comite = "at", conteudo_pagina = "agenda", orgao = "cbh")
  testthat::expect_gt(nrow(agenda_cbhat), 200)

  representantes_cbhpcj <- raspar_pagina_sigrh(sigla_do_comite = "pcj", conteudo_pagina = "representantes", orgao = "cbh")
  testthat::expect_gt(nrow(representantes_cbhpcj), 50)

  atas_cbhpcj <- raspar_pagina_sigrh(sigla_do_comite = "pcj", conteudo_pagina = "atas", orgao = "cbh")
  testthat::expect_gt(nrow(atas_cbhpcj), 100)

  deliberacoes_cbhalpa <- raspar_pagina_sigrh(sigla_do_comite = "alpa", conteudo_pagina = "deliberacoes", orgao = "cbh")
  testthat::expect_gt(nrow(deliberacoes_cbhalpa), 200)

})
