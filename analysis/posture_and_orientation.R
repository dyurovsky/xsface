# note: depends on "data/consolidated_data.csv" being open

######## ANALYSIS OF POSTURES BY AGES ##########  
pss <- ddply(d, ~ subid + posture + age.grp, summarise, 
             time = na.sum(dt))

pss <- ddply(pss,~subid + age.grp,
             function(x) { # can't find a better way to do this
               x <- subset(x,!is.na(posture))
               x$time <- round(x$time / sum(x$time),4)
               return(x)})

ps <- ddply(pss, ~ posture + age.grp,  summarise, #.drop=FALSE,
            mtime = mean(time),
            cih = ci.high(time),
            cil = ci.low(time))
ps$mtime[is.na(ps$mtime)] <- 0

# pdf("~/Projects/xsface/writeup/figures/posture.pdf",width=4,height=2.5)
qplot(age.grp,mtime,colour=posture,pch=posture,
      ymin=mtime-cil,ymax=mtime+cih,
      data=subset(ps,posture!="other"),
      position=position_dodge(.7),
      ylab="Proportion Time",xlab="Age (months)",xlim=c(4,20),
      geom=c("pointrange","line")) + 
  scale_x_continuous(breaks=c(8,12,16))
# dev.off()

# simplified
# quartz()
qplot(age.grp,mtime,colour=posture,pch=posture,
      ymin=mtime-cil,ymax=mtime+cih,
      data=subset(ps,posture!="other" & posture!="carry" & posture!="lie"),
      position=position_dodge(.1),
      ylab="Proportion Time",xlab="Age (months)",xlim=c(4,20),
      geom=c("pointrange","line")) + 
  scale_x_continuous(breaks=c(8,12,16))

######## ANALYSIS OF ORIENTATIONS BY AGES ##########  
oss <- ddply(d, ~ subid + orientation + age.grp, summarise, 
             time = na.sum(dt))

oss <- ddply(oss,~subid + age.grp,
             function(x) { # can't find a better way to do this
               x <- subset(x,!is.na(orientation))
               x$time <- round(x$time / sum(x$time),4)
               return(x)})

os <- ddply(oss, ~ orientation + age.grp, .drop=FALSE, summarise, 
            t = mean(time),
            cih = ci.high(time),
            cil = ci.low(time))
os$t[is.na(os$t)] <- 0

# pdf("~/Projects/xsface/writeup/figures/orientation.pdf",width=4,height=2.5)
qplot(age.grp,t,colour=orientation,pch=orientation,
      ymin=t-cil,ymax=t+cih,
      data=subset(os,orientation!="other"),
      position=position_dodge(.1),
      ylab="Proportion Time",xlab="Age (months)",xlim=c(4,20),
      geom=c("pointrange","line")) + 
  scale_x_continuous(breaks=c(8,12,16)) 
# dev.off()

######## ANALYSIS OF POSTURES AND ORIENTATIONS ##########  
poss <- ddply(d, ~ subid + posture + orientation + age.grp, summarise, 
             time = na.sum(dt))

poss <- ddply(poss,~subid + age.grp,
             function(x) { # can't find a better way to do this
               x <- subset(x,!is.na(orientation) & !is.na(posture))
               x$time <- round(x$time / sum(x$time),4)
               return(x)})

pos <- ddply(poss, ~ posture + orientation + age.grp, summarise, 
            t = mean(time),
            cih = ci.high(time),
            cil = ci.low(time))
pos$t[is.na(os$t)] <- 0

# pdf("~/Projects/xsface/writeup/figures/orientation.pdf",width=4,height=2.5)
qplot(age.grp,t,colour=posture,pch=posture,
      ymin=t-cil,ymax=t+cih,
      facets=~orientation,
      data=subset(pos,orientation!="other"),
      position=position_dodge(.1),
      ylab="Proportion Time",xlab="Age (months)",xlim=c(4,20),
      geom=c("pointrange","line")) + 
  scale_x_continuous(breaks=c(8,12,16)) 
# dev.off()



