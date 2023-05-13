# The Loan Rangers

This repo contains the data and code for my Shiny App, [The Loan Rangers](https://loanrangers.info), visualizing links between Tory politicians, companies and people related to the Loan Charge Scandal.

The Loan Rangers is based on the original [My Little Crony](https://sophieehill.shinyapps.io/my-little-crony/) by [Sophie E. Hill](https://www.sophie-e-hill.com/).

## References
[Setup SSL with Docker, nginx and Lets Encrypt](https://www.programonaut.com/setup-ssl-with-docker-nginx-and-lets-encrypt/)

## Data
The raw data is contained in two files: `people.csv` identifies individuals and organizations (i.e. the "nodes" of the network) and `connections.csv` identifies the links between individuals and organizations (i.e. the "edges" of the network).

## Code
The script `code.R` adds some attributes to the data to aid visualization, like specifying the icon type, colour, size. The data files are then resaved as `people.RData` and `connections.RData`.

## Shiny app
The file `app.R` contains the Shiny app. It can be run locally on your machine or you can see the final product [here on the web](https://loanrangers.info)!

## Build the Docker image locally
`docker build -t theloanrangers:latest .`
#### for not running docker, use save:
`docker save theloanrangers:latest | gzip > tlr_latest.tar.gz`
#### for running or paused docker, use export:
`docker export theloanrangers:latest | gzip > tlr_latest.tar.gz`
## Loading the Docker image
`gunzip -c tlr_latest.tar.gz | docker load`

## Certificate initialisation
- Rename `nginx.conf.1` to `nginx.conf`
- Run `docker-compose up -d certbot`
- Revert `nginx.conf` back

## Certificate auto renewal
- Initialise crontab with `crontab -e`
- Add `0 5 1 */2 *  /usr/local/bin/docker-compose up -f /var/docker/docker-compose.yml certbot`

## Newbie
### Install R from https://cran.r-project.org/
### Update your ~/.Rprofile with:
    local({r <- getOption("repos")
       r["CRAN"] <- "https://cloud.r-project.org"
       options(repos=r)
    )
### In the my-little-crony directory run (first time):
    $ R 
    > install.packages("rsconnect")
    > install.packages("visNetwork")
    > install.packages("tidyverse")
    > install.packages("metathis")
    > install.packages("igraph")
    > install.packages("shiny")
### Set the connection info
    rsconnect::setAccountInfo(name='the-loan-rangers', token='<TOKEN>', secret='<SECRET>')
### Run the app:
    R -e "shiny::runApp('.')"
