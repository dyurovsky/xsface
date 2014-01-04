## check lengths on movies
demo <- read.csv("data/demographics/demographics.csv")
movies <- read.csv("data/movie_lengths.csv")
dets <- read.csv("data/all_detectors.csv")


demo$demo.len.sec <- sapply(strsplit(as.character(demo$len),":"),
                           function(x) {
                             x <- as.numeric(x)
                             x[1]*60+x[2]
                           }
)

det.lens <- 
  ddply(dets,.(subid), function(x) {
    y <- data.frame(subid=x$subid[1],
                    n.frames.det=max(x$frame))
    return(y)
  })

demo$id <- str_sub(as.character(demo$subid),start=4,end=8)
movies$id <- str_sub(as.character(movies$subid),start=4,end=7)
movies$movie.length <- movies$length
movies$movie.last.frame <- movies$last.frame

all.lens <- merge(demo,lens,by.x="id",by.y="id")
all.lens$id.n <- as.numeric(all.lens$id)
all.lens <- merge(all.lens, det.lens, by.x="id.n", by.y="subid")

## TESTS
all.lens$subid.x[floor(all.lens$length) != all.lens$len.sec]
all.lens$subid.x[abs(all.lens$movie.last.frame - all.lens$n.frames.det) > 2]
