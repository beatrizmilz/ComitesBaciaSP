test_that("raspar_pagina_sigrh() works", {


  # comprimento dos argumentos
  testthat::expect_error(raspar_pagina_sigrh(
      sigla_do_comite = c("at", "ps"),
      conteudo_pagina = "agenda",
      orgao = "cbh"
    ))

  # Comitês --------
  testthat::expect_error(raspar_pagina_sigrh(sigla_do_comite = "at"))

  agenda_cbhat <-
    raspar_pagina_sigrh(
      sigla_do_comite = "at",
      conteudo_pagina = "agenda",
      orgao = "cbh"
    )
  testthat::expect_gt(nrow(agenda_cbhat), 200)

  representantes_cbhpcj <-
    raspar_pagina_sigrh(
      sigla_do_comite = "pcj",
      conteudo_pagina = "representantes",
      orgao = "cbh"
    )
  testthat::expect_gt(nrow(representantes_cbhpcj), 50)

  atas_cbhpcj <-
    raspar_pagina_sigrh(
      sigla_do_comite = "pcj",
      conteudo_pagina = "atas",
      orgao = "cbh"
    )
  testthat::expect_gt(nrow(atas_cbhpcj), 100)

  deliberacoes_cbhalpa <-
    raspar_pagina_sigrh(
      sigla_do_comite = "alpa",
      conteudo_pagina = "deliberacoes",
      orgao = "cbh"
    )
  testthat::expect_gt(nrow(deliberacoes_cbhalpa), 200)

  documentos_cbhsmt <-
    raspar_pagina_sigrh(
      sigla_do_comite = "smt",
      conteudo_pagina = "documentos",
      orgao = "cbh"
    )
  testthat::expect_gt(nrow(documentos_cbhsmt), 100)

  # Agências -------
  testthat::expect_error(raspar_pagina_sigrh(
    sigla_do_comite = "smt",
    conteudo_pagina = "documentos",
    orgao = "agencia"
  ))

  testthat::expect_error(raspar_pagina_sigrh(
    sigla_do_comite = "at",
    conteudo_pagina = "documentos",
    orgao = "agencia"
  ))

  testthat::expect_error(raspar_pagina_sigrh(
    sigla_do_comite = "ps",
    conteudo_pagina = "atas",
    orgao = "agencia"
  ))

  atas_agencia_at <- raspar_pagina_sigrh(
    sigla_do_comite = "at",
    conteudo_pagina = "atas",
    orgao = "agencia"
  )

  testthat::expect_gt(nrow(atas_agencia_at), 50)

  # alguns que são despadronizados

  # mp
  representantes_cbhpmp <-
    raspar_pagina_sigrh(
      sigla_do_comite = "mp",
      conteudo_pagina = "representantes",
      orgao = "cbh"
    )
  testthat::expect_gt(nrow(representantes_cbhpmp), 80)

  # pp
  representantes_cbhpp <-
    raspar_pagina_sigrh(
      sigla_do_comite = "pp",
      conteudo_pagina = "representantes",
      orgao = "cbh"
    )
  testthat::expect_gt(nrow(representantes_cbhpp), 60)


  # smg
  representantes_cbhsmg <-
    raspar_pagina_sigrh(
      sigla_do_comite = "smg",
      conteudo_pagina = "representantes",
      orgao = "cbh"
    )
  testthat::expect_gt(nrow(representantes_cbhsmg), 60)

  # pp
  atas_cbhpp <-
    raspar_pagina_sigrh(
      sigla_do_comite = "pp",
      conteudo_pagina = "atas",
      orgao = "cbh"
    )

  testthat::expect_gt(nrow( atas_cbhpp), 60)

  # crh ------------
  agenda_crh <-
    raspar_pagina_sigrh(
      sigla_do_comite = "crh",
      conteudo_pagina = "agenda",
      orgao = "crh"
    )
  testthat::expect_gt(nrow(agenda_crh), 50)

  representantes_crh <-
    raspar_pagina_sigrh(
      sigla_do_comite = "crh",
      conteudo_pagina = "representantes",
      orgao = "crh"
    )
  testthat::expect_gt(nrow(representantes_crh), 100)

  documentos_crh <-
    raspar_pagina_sigrh(
      sigla_do_comite = "crh",
      conteudo_pagina = "documentos",
      orgao = "crh"
    )
  testthat::expect_gt(nrow(documentos_crh), 100)

  atas_crh <-
    raspar_pagina_sigrh(
      sigla_do_comite = "crh",
      conteudo_pagina = "atas",
      orgao = "crh"
    )
  testthat::expect_gt(nrow(atas_crh), 50)

  deliberacoes_crh <-
    raspar_pagina_sigrh(
      sigla_do_comite = "crh",
      conteudo_pagina = "deliberacoes",
      orgao = "crh"
    )
  testthat::expect_gt(nrow(deliberacoes_crh), 300)


})
