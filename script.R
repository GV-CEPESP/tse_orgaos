teste <- httr::GET(url_teste)

teste %>% 
  httr::content(as = "text") %>% 
  jsonlite::fromJSON()

