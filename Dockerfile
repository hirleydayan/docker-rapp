# Include R-Base version predefined version variable
ARG RBASE_VERSION

# Install R Base
FROM r-base:${RBASE_VERSION}

# Copy OS and R requirements files to container
# Linux package requirements and R libraries requirements
# should be listed in those files
COPY linux_requirements.txt /tmp/linux_requirements.txt
COPY app/requirements.txt /tmp/r_app_requirements.txt

# Add Shiny APP folder to the container
ADD /app /srv/shiny-server/app

# Shiny startup shell script into the container
COPY shiny-server.sh /usr/bin/shiny-server.sh

# Include Shiny version predefined version variable
ARG SHINY_PACKAGE

# Install all Linux and R required packages and libraries, respectivelly, in the container
RUN chmod +x /usr/bin/shiny-server.sh && \
    apt-get update && \
    apt-get install && \
    cat /tmp/linux_requirements.txt | xargs -I {} apt-get install -y {} && \
    wget --no-verbose ${SHINY_PACKAGE} -O shiny-server.deb && \
    gdebi -n shiny-server.deb && \
    rm -f shiny-server.deb && \
    R -e "reqs <- scan('tmp/r_app_requirements.txt', character()); install.packages(reqs, repos='http://cran.rstudio.com/')"

# Copy configuration file into the container
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

# Copy index.html into the container
COPY index.html /srv/shiny-server/index.html

# Expose Shiny app port
EXPOSE 3838

# Set logging level predefined level variable
ENV SHINY_LOG_LEVEL=${SHINY_LOG_LEVEL}

# RUN Shiny server
CMD ["/usr/bin/shiny-server.sh"]