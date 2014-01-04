## some descriptives and demographics
all.subs <- read.csv("data/demographics/all_participants.csv")
inc.subs <- read.csv("data/demographics/demographics.csv")

inc.subs$len <- sapply(strsplit(as.character(inc.subs$len),":"),
       function(x) {
         x <- as.numeric(x)
         x[1]+x[2]/60
       }
)

aggregate(cbind(age.at.test,len) ~ age.grp, data=inc.subs, mean)

aggregate(subID ~ reason, data=all.subs, length)
aggregate(subID ~ age_group + reason , data=all.subs, length)
