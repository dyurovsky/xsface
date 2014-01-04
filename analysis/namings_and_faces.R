  ######## ANALYSIS OF NAMINGS ##########
  # sb <- ddply(d,~subid, summarize.naming, window=c(-3,0))
  # sa <- ddply(d,~subid, summarize.naming, window=c(0,3))
  # sb$window <- "before"
  # sa$window <- "after"
  # s <- rbind(sb,sa)
  # s$window <- factor(s$window)
  
  d <- subset(d,!is.na(time))
  s <- ddply(d,~subid, summarize.naming, window=c(-2,2))
  
  s$first.instance <- s$naming.instance == 1
  s$log.instance <- round(log10(s$naming.instance)*4)/4
  s$binned.instance <- 10^(round(log10(s$naming.instance)*4)/4)
  s$face.logical <- s$face != 0
  
  ## try plotting individuals
  mss <- ddply(s,~subid+age.grp+familiarity,summarise,
               face = na.mean(face))
  
  pdf("~/Projects/xsface/writeup/figures/naming_faces.pdf",width=4,height=3)
  qplot(age.grp,face,colour=familiarity,
        position = position_dodge(.7),log="x",
        xlab="Age (Months)",ylab="Proportion faces detected in window",
        data=mss,geom=c("point")) + 
    scale_x_continuous(breaks=c(4,8,12,16,20)) +
    stat_summary(fun.data="mean_cl_boot",position=position_dodge(.7)) +
    plot.style
  dev.off()
  
  
  ## now calculate differences from base rate
  n <- ddply(s,~subid+age.grp,summarise,
             face = na.mean(face))
  
  n$br <- ddply(d,~subid+age.grp,summarise,
              face=na.mean(face))$face
  
  n$br.diff <- n$face - n$br
  
  pdf("~/Projects/xsface/writeup/figures/naming_faces_diff.pdf",width=4,height=3)
  qplot(age.grp,br.diff,position=position_jitter(.2),
        data=subset(n,age.grp>4),xlab="Age (Months)",ylab="Face detections relative to base rate") + 
    scale_x_continuous(breaks=c(8,12,16,20)) +
    geom_abline(slope=0,intercept=0,lty=2) + 
    stat_summary(fun.data="mean_cl_boot",color="red") +
    plot.style
  dev.off()