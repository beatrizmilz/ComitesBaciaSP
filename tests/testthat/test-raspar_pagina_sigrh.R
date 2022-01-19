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

  documentos_cbhsmt <- raspar_pagina_sigrh(sigla_do_comite = "smt", conteudo_pagina = "documentos", orgao = "cbh")
  testthat::expect_gt(nrow(documentos_cbhsmt), 100)

  documentos_cbhmp <- raspar_pagina_sigrh(sigla_do_comite = "mp", conteudo_pagina = "documentos", orgao = "cbh")
  testthat::expect_gt(nrow(documentos_cbhmp), 100)

#
#   mp_caminho <- "../RelatoriosTransparenciaAguaSP/inst/dados_html/2021/10/mp-documentos-01-10-2021.html"
#   docs <- raspar_pagina_sigrh(sigla_do_comite = "mp", conteudo_pagina = "documentos", orgao = "cbh", online = FALSE, path_arquivo = mp_caminho)


})
