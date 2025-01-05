
source("./src/data/shared.R") 

source("./src/data/r_networks_two.R")

## make a zip which could have several objects

# Add to zip archive, write to stdout.
setwd(tempdir())
write_json(bn_two_json, "bn-two-networks.json")
system("zip - -r .")

