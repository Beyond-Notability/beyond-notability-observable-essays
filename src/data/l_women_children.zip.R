
source("./src/data/shared.R") 

source("./src/data/r_women_children.R")




# Add to zip archive, write to stdout
setwd(tempdir())
write_csv(bn_had_children_ages, "had-children-ages.csv", na="")
write_csv(bn_last_ages_all, "last-ages-all.csv", na="")
write_csv(bn_work_served_spoke_years_children, "work-served-spoke-years-with-children.csv", na="")
system("zip - -r .")  

