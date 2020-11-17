FROM rocker/shiny-verse

#update all packages
RUN apt-get update

#upgrade
RUN apt-get upgrade -y

#install packaes needed for running the app
RUN R -e "install.packages(c('visNetwork', 'tidyverse', 'metathis'))"

COPY ./ /srv/shiny-server/
