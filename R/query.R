#'

url_base <- "http://inter01.tse.jus.br/sgip3-consulta/api/v1/orgaoPartidario/"

list(
  "Nacional"     = 81,
  "Estadual"     = 82,
  "Municipal"    = 83,
  "Regional(DF)" = 84,
  "Zonal(DF)"    = 85
)

get_orgaos <- function(base, state, party = 0, history = F){
  endpoint <- "consulta"
  url_use <- stringr::str_c(url_base, endpoint)
  
  query_to_use <- build_query(endpoint)
  
}

get_members <- function(id_orgao){
  endpoint <- "comAnotacoesEMembros"
  url_use <- stringr::str_c(url_base, endpoint)
  
  query_to_use <- build_query(endpoint, id_orgao)
  
  
}

build_query <- function(){
  
  if(endpoint == "consulta"){
    query_orgaos <- list(
      `nrZona`                  = ,
      `sgUe`                    = ,
      `sgUeSuperior`            = ,
      `sqPartido`               = ,
      `tpAbrangencia`           = ,
      `isComposicoesHistoricas` =
    )
  } else if(endpoint == "comAnotacoesEMembros"){
    query_membros <- list(
      `idOrgaoPartidario`       = 
    )
  }
}

make_query <- function(url_use, query){
  httr::GET(url_use, query) %>% 
    httr::content(as = "text", encoding = "UTF-8") %>% 
    jsonlite::fromJSON()
}