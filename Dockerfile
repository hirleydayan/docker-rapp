ARG RBASE_VERSION
ARG SHINY_VERSION
ARG SHINY_LOG_LEVEL

# Install R Base
FROM r-base:${RBASE_VERSION}

# Logging level
ENV SHINY_LOG_LEVEL ${SHINY_LOG_LEVEL}
ENV SHINY_VERSION ${SHINY_VERSION}

# Copy OS and R requirements files to container
# Linux package requirements and R libraries requirements
# should be listed in those files
COPY linux_requirements.txt /tmp/linux_requirements.txt
COPY r_app_requirements.txt /tmp/r_app_requirements.txt

# Add Shiny APP folder to the container
ADD /app /srv/shiny-server/app

# Shiny startup shell script into the container
COPY shiny-server.sh /usr/bin/shiny-server.sh

# Install Linux required packages
RUN chmod +x /usr/bin/shiny-server.sh && \
    apt-get update && \
    apt-get install && \
    cat /tmp/linux_requirements.txt | xargs -I {} apt-get install -y {} && \
    wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.16.958-amd64.deb -O shiny-server.deb && \
    gdebi -n shiny-server.deb && \
    rm -f shiny-server.deb && \
    R -e "reqs <- scan('tmp/r_app_requirements.txt', character()); install.packages(reqs, repos='http://cran.rstudio.com/')"

# Copy configuration files
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

# Copy configuration files
COPY index.html /srv/shiny-server/index.html

# Expose ShinyApp port
EXPOSE 3838

# RUN Shiny server
CMD ["/usr/bin/shiny-server.sh"]