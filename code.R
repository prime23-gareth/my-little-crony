# set working directory

library(tidyverse)
library(visNetwork)
library(igraph)

# load network data
people <- read_csv("people.csv")
connections <- read_csv("connections.csv")

# sort people alphabetically so that the selection list is easier to follow
people <- people[order(people$id),]

# calculate degree cenrality in order to scale nodes
graph <- igraph::graph.data.frame(connections, directed = F)
degree_value <- degree(graph, mode = "in")
sort(degree_value)
# scaling factor 
people$icon.size <- degree_value[match(people$id, names(degree_value))] + 80

sort(betweenness(graph, v=V(graph), directed=FALSE))

# add attributes
people$label <- people$id
people <- people %>% mutate(shape = "icon",
                            icon.color = case_when(type=="person" ~ "lightblue",
                                              type=="firm" ~ "#7b889c",
                                              type=="political party" ~ "#3377d6",
                                              type=="government" ~ "#3377d6",
                                              type=="scheme" ~ "#ade0b9",
                                              type=="demand" ~ "#d48ed1",
                                              type=="unknown" ~ "black",
                                              type=="trust" ~ "purple", 
                                              type=="group" ~ "black",
                                              type=="tax haven" ~ "#489749",
                                              type=="trustee" ~ "brown",
                                              type=="news" ~ "grey"),
                            icon.code = case_when(type=="person" ~ "f007",
                                              type=="firm" ~ "f1ad",
                                              type=="political party" ~ "f0c0",
                                              type=="government" ~ "f19c",
                                              type=="scheme" ~ "f1b8",
                                              type=="demand" ~ "f1e2",
                                              type=="unknown" ~ "f21b",
                                              type=="trust" ~ "f2b5",
                                              type=="group" ~ "f0c0",
                                              type=="tax haven" ~ "f155",
                                              type=="trustee" ~ "f2b2",
                                              type=="news" ~ "f1ea"),
                            icon.face = "FontAwesome",
                            icon.weight = "bold")
people$title <- paste0("<p>", people$desc,"</p>")
people$font.size <- people$icon.size/2

# connections$label <- connections$type
connections$title <- paste0("<p>", connections$detail, "</p>")
# color edges according to type
connections <- connections %>% mutate(color = case_when(type=="contract" ~ "#f77272",
                                                        type=="donor" ~ "#76a6e8",
                                                        TRUE ~ "#dbd9db"))
connections$value <- ifelse(is.na(connections$contract_size), 5, connections$contract_size)
# make sure "value" is saved as an integer variable
connections$value <- as.integer(as.character(connections$value))

# save datasets to call in Shiny
save(people, file = "people.RData")
save(connections, file = "connections.RData")

# make graph
visNetwork(nodes=people, edges=connections, width = "100%") %>% 
  visEdges(scaling=list(min=4, max=40)) %>%
  visNodes(scaling=list(min=40, max=50)) %>%
  visOptions(highlightNearest = list(enabled = T, degree = 2, hover = T)) %>%
  visInteraction(hover=TRUE, zoomView = TRUE) %>%
  visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -50)) %>%
  addFontAwesome() %>%
visLayout(randomSeed = 12) # to have always the same network  


