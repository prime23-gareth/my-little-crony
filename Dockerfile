FROM rocker/shiny-verse:latest

# Used for healthchecks
RUN apt-get update && apt-get install -y curl

RUN rm -r /srv/shiny-server/*
COPY . /srv/shiny-server/
RUN chown -R shiny:shiny /srv/shiny-server

RUN R -e "install.packages('visNetwork', repos='https://cloud.r-project.org')"
RUN R -e "install.packages('tidyverse', repos='https://cloud.r-project.org')"
RUN R -e "install.packages('metathis', repos='https://cloud.r-project.org')"
RUN R -e "install.packages('igraph', repos='https://cloud.r-project.org')"
RUN R -e "install.packages('shiny', repos='https://cloud.r-project.org')"

USER shiny

COPY ./src/app.R /app.R

COPY ./src/*.RData /.
COPY ./src/*.html /.

EXPOSE 3838

CMD R -e 'shiny::runApp("app.R", port = 3838, host = "0.0.0.0")'
