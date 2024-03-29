% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_pagina_sigrh.R
\name{download_pagina_sigrh}
\alias{download_pagina_sigrh}
\title{Função para fazer download das páginas em HTML do SigRH}
\usage{
download_pagina_sigrh(
  sigla_do_comite = c(ComitesBaciaSP::comites_sp$sigla_comite, "crh"),
  path = here::here("html"),
  pagina = c("representantes", "atas", "atas_agencia", "deliberacoes", "documentos",
    "agenda")
)
}
\arguments{
\item{sigla_do_comite}{Texto referente à sigla do(s) comitê(s). Pode ser informado um vetor de siglas. É possível verificar na base:  \code{\link{comites_sp}}. Por padrão, utiliza um vetor com a sigla de todos os comitês.}

\item{path}{O caminho onde o(s) arquivo(s) HTMl deve(m) ser baixado(s).}

\item{pagina}{Palavra (texto) apontando qual página deve acessada para realizar o download. Possibilidades: "representantes", "atas", "atas_agencia", "deliberacoes", "documentos", "agenda". Por padrão, utiliza um vetor com todas as possibilidades.}
}
\value{
Mensagens no console apontando o que foi baixado.
}
\description{
Função para fazer download das páginas em HTML do SigRH
}
\examples{
# download_pagina_sigrh()
}
