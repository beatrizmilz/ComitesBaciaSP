## code to prepare `agencias_de_bacia_sp` dataset goes here

agencias_de_bacia_sp <- tibble::tibble(
  nome = character(),
  sigla = character(),
  sigla_agencia = character(),
  sigla_comite = character(),
  url_atas = character(),
  site_sigrh = character(),
  site_alternativo = character()
) |>
  tibble::add_row(
    nome = "Fundação Agência da Bacia Hidrográfica do Alto Tietê",
    sigla = "FABHAT",
    sigla_agencia = "fabhat",
    sigla_comite = "at",
    site_sigrh = "https://sigrh.sp.gov.br/fabhat/apresentacao",
    url_atas = "https://sigrh.sp.gov.br/fabhat/apresentacao",
    site_alternativo = "http://fabhat.org.br/"
  )|>
  tibble::add_row(
    nome = "Agência das Bacias dos Rios Piracicaba, Capivari e Jundiaí",
    sigla = "Agência PCJ",
    sigla_agencia = "agenciapcj",
    sigla_comite = "pcj",
    url_atas = NA,
    site_sigrh = "https://sigrh.sp.gov.br/agenciapcj/apresentacao",
    site_alternativo = "https://agencia.baciaspcj.org.br/",
  ) |>
  tibble::add_row(
    nome = "Associação Pró-Gestão das Águas da Bacia Hidrográfica do Rio Paraíba do Sul",
    sigla = "AGEVAP",
    sigla_agencia = "agevap",
    sigla_comite = "ps",
    url_atas = NA,
    site_sigrh = "https://sigrh.sp.gov.br/agevap/apresentacao",
    site_alternativo = "https://www.agevap.org.br/index.php",
  )  |>
  tibble::add_row(
    nome = "Fundação Agência da Bacia do Rio Sorocaba e Médio Tietê",
    sigla = "FABH-SMT",
    sigla_agencia = "fabhsmt",
    sigla_comite = "smt",
    url_atas = NA,
    site_sigrh = "https://sigrh.sp.gov.br/fabhsmt/apresentacao",
    site_alternativo = "https://www.agenciasmt.com.br/",
  )

usethis::use_data(agencias_de_bacia_sp, overwrite = TRUE)
