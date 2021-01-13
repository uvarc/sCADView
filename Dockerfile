FROM r-base:latest

RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libsodium-dev \
    libssl-dev \
    libv8-dev \
    libxml2-dev \
    r-cran-rmysql \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    git \
    libxt-dev && \
    wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt) && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('BiocManager', 'shiny', 'shinythemes', 'Seurat', 'plotly', 'shinybusy'))" && \
    rm -rf /var/lib/apt/lists/*
    
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN rm -rf /srv/shiny-server/*

RUN git clone https://github.com/uvarc/sCADView.git
RUN cp -rf sCADView/app.R /srv/shiny-server/.

CMD ["/usr/bin/shiny-server.sh"]