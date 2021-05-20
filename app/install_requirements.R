reqs <- scan('tmp/r_app_requirements.txt', character()); 
install.packages(reqs, repos='http://cran.rstudio.com/')