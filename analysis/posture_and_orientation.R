######## ANALYSIS OF POSTURES BY AGES ##########  
pss <- ddply(d, ~ subid + posture + age.grp, summarise, 
             time = na.sum(dt))

pss <- ddply(pss,~subid + age.grp,
             function(x) { # can't find a better way to do this
               x <- subset(x,!is.na(posture))
               x$time <- round(x$time / sum(x$time),4)
               return(x)})

ps <- ddply(pss, ~ posture + age.grp, .drop=FALSE, summarise, 
            mtime = mean(time),
            cih = ci.high(time),
            cil = ci.low(time))
ps$mtime[is.na(ps$mtime)] <- 0

pdf("~/Projects/xsface/writeup/figures/posture.pdf",width=4,height=2.5)
qplot(age.grp,mtime,colour=posture,pch=posture,
      ymin=mtime-sem,ymax=mtime+sem,
      data=subset(ps,posture!="other"),
      position=position_dodge(.7),
      ylab="Proportion Time",xlab="Age (months)",xlim=c(4,20),
      geom=c("pointrange","line")) + 
  scale_x_continuous(breaks=c(4,8,12,16,20)) +
  theme_bw()
dev.off()

# simplified
quartz()
qplot(age.grp,mtime,colour=posture,pch=posture,
      ymin=mtime-cil,ymax=mtime+cih,
      data=subset(ps,posture!="other" & posture!="carry" & posture!="lie"),
      position=position_dodge(.7),
      ylab="Proportion Time",xlab="Age (months)",xlim=c(4,20),
      geom=c("pointrange","line")) + 
  scale_x_continuous(breaks=c(4,8,12,16,20)) +
  theme_bw()

######## ANALYSIS OF ORIENTATIONS BY AGES ##########  
oss <- ddply(d, ~ subid + orientation + age.grp, summarise, 
             time = na.sum(dt))

oss <- ddply(oss,~subid + age.grp,
             function(x) { # can't find a better way to do this
               x <- subset(x,!is.na(orientation))
               x$time <- round(x$time / sum(x$time),4)
               return(x)})

os <- ddply(oss, ~ orientation + age.grp, .drop=FALSE, summarise, 
            time = mean(time),
            sem = sem(time))
os$time[is.na(os$time)] <- 0

pdf("~/Projects/xsface/writeup/figures/orientation.pdf",width=4,height=2.5)
qplot(age.grp,time,colour=orientation,pch=orientation,
      ymin=time-sem,ymax=time+sem,
      data=subset(os,orientation!="other"),
      position=position_dodge(.7),
      ylab="Proportion Time",xlab="Age (months)",xlim=c(4,20),
      geom=c("pointrange","line")) + 
  scale_x_continuous(breaks=c(4,8,12,16,20)) +
  theme_bw() + plot.style 
dev.off()


