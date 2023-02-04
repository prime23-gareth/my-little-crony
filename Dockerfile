FROM rocker/shiny-verse:latest

# Used for healthchecks
RUN apt-get update && apt-get install -y curl

RUN rm -r /srv/shiny-server/*
COPY . /srv/shiny-server/
RUN chown -R shiny:shiny /srv/shiny-server

RUN R -e "install.packages(c('visNetwork', 'tidyverse', 'metathis', 'igraph', 'shiny'))"

USER shiny

COPY ./src/app.R /.
COPY ./src/*.RData /.
COPY ./src/*.html /.

EXPOSE 3838

CMD R -e 'shiny::runApp("app.R", port = 3838, host = "0.0.0.0")'
