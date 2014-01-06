## main data merge script - prerequisite for all other analyses
setwd("~/Projects/headcam/xsface") # MCF specific convenience

rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
source("analysis/helper.R")

## load detectors
d <- read.csv("data/all_detectors.csv")

## load demographic data and merge
demo.data <- read.csv("data/demographics/demographics.csv")
d <- merge(d, demo.data[,c("subid","age.grp","age.at.test")], 
           by.x = "subid", by.y = "subid", 
           all.x = TRUE, all.y = FALSE)

## now add ground truth time to these
d <- ddply(d, ~subid, add.times)

## now add posture and orientation to these
d <- ddply(d, ~subid, add.posture)

write.csv(d,"data/consolidated_data.csv")
