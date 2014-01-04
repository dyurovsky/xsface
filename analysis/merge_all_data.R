rm(list=ls())

source("~/Projects/R/Ranalysis/useful.R")
source("analysis/helper.R")

## load detectors
dets <- read.csv("data/all_detectors.csv")

## load demographic data and merge
demo.data <- read.csv("~/Projects/xsface/data/demographics/demographics.csv")
d <- merge(dets, demo.data, by.x = "subid", by.y = "subid", 
           all.x = TRUE, all.y = FALSE)

## now add ground truth time to these
d <- ddply(d, ~subid, add.times)

## now add posture and orientation to these
d <- ddply(d, ~subid, add.posture)

## now add face pose
pose <- read.csv("data/face_pose.csv")
subs <- unique(d$subid)
d <- merge(d,pose[,c("subid","frame","angle")],by.x=c("subid","frame"), by.y=c("subid","frame"),all.x=TRUE)

write.csv(d,"~/Projects/xsface/data/all_dets_LDT_merged.csv")