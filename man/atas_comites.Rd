% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{atas_comites}
\alias{atas_comites}
\title{Atas de reuniões dos Comitês de Bacia Hidrográfica no Estado de São Paulo}
\format{
Uma tibble, contendo:
\describe{
  \item{data_coleta_dados}{Data em que os dados foram coletados, no formato ano-mês-dia (yyyy-mm-dd)}
  \item{site_coleta}{Link do site onde os dados foram coletados}
  \item{comite}{Nome do comitê de bacia}
  \item{n_ugrhi}{Número que representa a Unidade de Gerenciamento de Recursos Hídricos à qual o Comitê está relacionado}
  \item{nome_reuniao}{Nome da reunião, segundo informado pelo Comitê de Bacia}
  \item{data_reuniao}{Data da reunião, segundo informado pelo Comitê de Bacia, no formato ano-mês-dia (yyyy-mm-dd)}
  \item{data_postagem}{Data da postagem da ata de reunião, segundo informado pelo Comitê de Bacia, no formato ano-mês-dia (yyyy-mm-dd)}
  \item{numero_link}{Em alguns casos, há mais de um link para o arquivo da ata por reunião. Essa coluna contém a ordem dos arquivos.}
  \item{url_link}{URL, ou endereço online, do arquivo referente à ata da reunião.}
}
}
\source{
SigRH - \url{http://www.sigrh.sp.gov.br/}
}
\usage{
atas_comites
}
\description{
Tabela contendo informações sobre reuniões dos Comitês de Bacia Hidrográfica no Estado de São Paulo e link para as atas de reunião.
}
\examples{
atas_comites \%>\% dplyr::arrange(desc(data_postagem)) \%>\% head(10)
}
\keyword{datasets}
