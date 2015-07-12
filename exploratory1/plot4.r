source("./src/functions.r")

draw.plot.4 <- function() {
    png("plot4.png")
    par(mfrow=c(2,2))
    draw.plot.2(to.png=F)
    draw.voltage()
    draw.plot.3(to.png=F)
    draw.reactive()
    par(mfrow=c(1,1))
    dev.off()
}

twodays <- prepare.data()
draw.plot.4()
