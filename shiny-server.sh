#!/bin/sh

# Create the logs folder for the APP sets the folder ownership 
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server

exec shiny-server