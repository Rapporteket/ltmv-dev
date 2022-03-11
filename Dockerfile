FROM rapporteket/dev:main

LABEL maintainer "Are Edvardsen <are.edvardsen@helse-nord.no>"

ARG DB_HOST=db-ltmv
ENV DB_HOST=${DB_HOST}

# add registry dev config and R pkg dependencies
COPY --chown=rstudio:rstudio db.yml /home/rstudio/rap_config/
RUN cat /home/rstudio/rap_config/db.yml >> /home/rstudio/rap_config/dbConfig.yml \
    && rm /home/rstudio/rap_config/db.yml \
    && echo "DB_HOST=${DB_HOST}" >> /home/rstudio/.Renviron \
    && echo "DB_HOST=${DB_HOST}" >> /home/shiny/.Renviron \
    && R -e "install.packages(c('covr', \
                                'dplyr', \
                                'lintr', \
                                'magrittr', \
                                'rlang', \
                                'rpivotTable', \
                                'shiny', \
                                'shinyalert', \
                                'testthat'))" \
    && R -e "remotes::install_github(c('Rapporteket/rapbase@*release'))"
