FROM rocker/shiny-verse:latest

RUN apt-get update && apt-get install -y

#install packaes needed for running the app
RUN R -e "install.packages(c('shiny', 'visNetwork', 'tidyverse', 'metathis'))"

COPY ./App /srv/shiny-server

RUN sudo chown -R shiny:shiny /srv/shiny-server 
