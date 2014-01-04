## some descriptives and demographics

ms <- aggregate(face ~ subid + age, d, mean)
qplot(age,face, data=ms) + 
  geom_smooth()


demo.data <- read.csv("~/Projects/xsface/data/demographics/demographics.csv")

inc.data <- merge(demo.data,data.frame(subid=unique(d$subid)))

aggregate(cbind(gen=="f",age) ~ age.grp,data=demo.data,mean)