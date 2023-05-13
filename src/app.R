library(shiny)
library(visNetwork)
library(tidyverse)
library(metathis)

server <- function(input, output) {
    output$network <- renderVisNetwork({
        load("people.RData")
        load("connections.RData")
        
        visNetwork(people, connections, width = "160%", height = "150%") %>%
        visEdges(scaling=list(min=8, max=40)) %>%
        visNodes(scaling=list(min=100, max=100)) %>%
        visOptions(highlightNearest = list(enabled = T, degree = 1, hover = T),
                      nodesIdSelection=TRUE) %>%
        visInteraction(hover=TRUE, zoomView = TRUE, 
                      navigationButtons = TRUE,
                      tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;
                font-family: sans-serif;font-size:14px;font-color:#000000;background-color: #e3fafa;
                -moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;
                 border: 0px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);
                 max-width:200px;overflow-wrap: normal') %>%
        visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -150)) %>%
            addFontAwesome() %>%
            visLayout(randomSeed = 02143)
    })
}

ui <- fluidPage(
    # Google analytics scripts
    tags$head(includeHTML(("ga-head.html"))),    
    tags$body(includeHTML(("ga-body.html"))),    
    # metadata for social sharing
    meta() %>%
        meta_social(
            title = "The Loan Rangers",
            description = "An interactive visualization of cronyism related to the Loan Charge Scandal",
            url = "https://loanrangers.info",
            image = "https://parris.me.uk/i/loanrangers.png",
            image_alt = "An image for social media cards",
            twitter_creator = "@garethparris",
            twitter_card_type = "summary",
            twitter_site = "@garethparris"
        ),
    
    titlePanel("The Loan Rangers"),
    verticalLayout(p("A visualisation of the connections between", strong("Politicians, companies and people related to the Loan Charge Scandal."),
                   style = "font-size:20px;")),
    sidebarLayout(
        sidebarPanel(
        h4("Guide"),
        tags$ul(
            tags$li(em("Scroll")," to zoom"), 
            tags$li(em("Drag")," to move around"),
            tags$li(em("Hover"),"or ", em("tap"), "icons and connections for more info"), 
            style = "font-size:15px;"), 
        p("The lines represent:", style="font-size:15px"),
        p(HTML("&horbar;"), "government contracts", style="color:#f77272;font-size:15px"),
        p(HTML("&horbar;"), "political donations", style="color:#76a6e8;font-size:15px"),
        p(HTML("&horbar;"), "other connections (e.g. family, employer)", style="color:grey;font-size:15px"),
        br(),
        p("Thicker lines indicate more valuable donations.", style = "font-size:15px;"),
        hr(),
        p("My Little Crony originally created by", a(href="https://sophie-e-hill.com/", "Sophie E. Hill"),
          HTML("&bull;"),
         "Sophie's code on", a(href="https://github.com/sophieehill/my-little-crony", "Github"),
         HTML("&bull;"), 
         "This version forked and developed by Gareth",
         HTML("&bull;"), 
          "Follow me on",
          a(href="https://twitter.com/garethparris", "Twitter"),
         HTML("&bull;"), 
          "This site costs money",
         HTML("&bull;"), 
          "Support me here",
          a(href="https://ko-fi.com/garethparris", "Ko-Fi"),          
          style="font-size:15px;"), 
        width=3),
        mainPanel(
        visNetworkOutput("network", height="80vh", width="100%"), width=9
    )
  )
)

shinyApp(ui = ui, server = server)
