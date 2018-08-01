#' Extracts party organ datas from TSE
#' 
#' @export
#' 
#' @description 
#' 
#' A função get_orgaos extrai os orgãos partidádios de acordo com o nível regional utilizado pelo usuário.
#' 
#' * \code{get_orgaos()} extracts information about the party organ.
#' 
#' * \code{get_members()} extracts members informations from a specified organ.
#' 
#' @param agreg character - regional agregation desired. (nacional, estadual, municipal, regional(DF), zona(DF)
#' 
#' @param partido integer - party numver. 0 returns data from all parties.
#' 
#' @param zona integer - zone number. Only used with zona(DF) regional agregation.
#' 
#' @param uni_eleitoral character or integer - Electoral unity. Should not be used with nacional agregation. 
#' When used with "estadual" regional agregation, a state should be specified (ex. "SP", "RJ", "BA", etc.).
#' When used with "municipal" regional agregation, the municipality TSE number should be specified.
#'  
#' @param uni_eleitoral_superior character - Only used with "municipal" regional agregation. The state should be specified (ex. "SP", "RJ", "BA", etc.).
#' 
#' @param history character - false or true. If true, the API request will return data from previous years.
#'


get_orgaos <- function(agreg, partido = 0, zona = 0, uni_eleitoral = NULL, uni_eleitoral_superior = NULL, history = "false"){
  endpoint <- "consulta"
  url_use <- stringr::str_c(url_base, endpoint)
  agreg_use <- switch_agreg(agreg)
  query_to_use <- build_query(endpoint, zona, uni_eleitoral, uni_eleitoral_superior, partido, agreg_use, history)
  make_query(url_use, query_to_use)
}

#' @export
get_members <- function(id_orgao){
  endpoint <- "comAnotacoesEMembros"
  url_use <- stringr::str_c(url_base, endpoint)
  query_to_use <- build_query(endpoint, id_orgao = id_orgao)
  members_ls <- make_query(url_use, query_to_use)
  members_df <- members_ls[["membros"]]
}

url_base <- "http://inter01.tse.jus.br/sgip3-consulta/api/v1/orgaoPartidario/"

switch_agreg <- function(agreg){
  switch_list <- list(
    "nacional"     = 81,
    "estadual"     = 82,
    "municipal"    = 83,
    "regional(DF)" = 84,
    "zonal(DF)"    = 85
  )
  switch_list[[agreg]]
}

build_query <- function(endpoint, zona = NULL, uni_eleitoral = NULL, uni_eleitoral_superior = NULL, partido = NULL, agreg = NULL, history = NULL, id_orgao = NULL){
  
  if(endpoint == "consulta"){
    query_orgaos <- list(
      `nrZona`                  = zona,
      `sgUe`                    = uni_eleitoral,
      `sgUeSuperior`            = uni_eleitoral_superior,
      `sqPartido`               = partido,
      `tpAbrangencia`           = agreg,
      `isComposicoesHistoricas` = history
    )
  } else if(endpoint == "comAnotacoesEMembros"){
    query_membros <- list(
      `idOrgaoPartidario`       = id_orgao
    )
  }
}

make_query <- function(url_use, query){
  get_res <- httr::GET(url_use, query = query)
  
  content_res <- httr::content(get_res, as = "text", encoding = "UTF-8")
  
  json_res <- jsonlite::fromJSON(content_res)
}
