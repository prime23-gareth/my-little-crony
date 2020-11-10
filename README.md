# My Little Loan Crony

This repo contains the data and code for my Shiny App, [My Little Loan Crony](Based on the original My Little Crony https://sophieehill.shinyapps.io/my-little-crony/), visualizing links between Tory politicians, private companies and people related to the Loan Charge Scandal.

## Data
The raw data is contained in two files: `people.csv` identifies individuals and organizations (i.e. the "nodes" of the network) and `connections.csv` identifies the links between individuals and organizations (i.e. the "edges" of the network).

## Code
The script `code.R` adds some attributes to the data to aid visualization, like specifying the icon type, colour, size. The data files are then resaved as `people.RData` and `connections.RData`.

## Shiny app
The file `app.R` contains the Shiny app. It can be run locally on your machine or you can see the final product [here on the web](https://my-little-loan-crony.shinyapps.io/my-little-loan-crony/)!
