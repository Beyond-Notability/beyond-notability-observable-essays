
source("./src/data/shared.R") 

source("./src/data/r_networks_two_prep.R")

source("./src/data/r_networks_two.R")

## make a zip which could have several objects

# Add to zip archive, write to stdout.
setwd(tempdir())
write_json(bn_two_json, "bn-two-networks.json")
#write_json(bn_events_json, "bn-two-events-network.json")
#write_json(bn_two_nodes_meta_json, "bn-two-nodes-meta.json")
system("zip - -r .")
