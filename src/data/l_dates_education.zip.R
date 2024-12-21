
# shared libraries, functions etc ####


source("./src/data/shared.R") 

source("./src/data/r_dates_education.R")
  
## if zip not needed, convert?
## make a zip with several objects

# Add to zip archive, write to stdout.
setwd(tempdir())
write_json(bn_women_education_degrees2, "educated_degrees2.json")
system("zip - -r .")
    