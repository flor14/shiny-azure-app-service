FROM rocker/r-ver:4.2.0

# Install system dependencies needed for compiling packages like httpuv
RUN apt-get update && apt-get install -y \
    libz-dev \
    pkg-config \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean
    
ENV RENV_VERSION=v1.0.2
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"
RUN R -e "options(renv.config.repos.override = 'https://packagemanager.posit.co/cran/latest')"

COPY . /app

WORKDIR /app

RUN R -e "renv::restore()"

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('./app.R', host='0.0.0.0', port=3838)"]
