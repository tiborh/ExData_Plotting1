source("./src/functions.r")

draw.plot.1 <- function(to.png=T) {
    if (to.png==T)
        png("plot1.png")
    hist(twodays$Global_active_power,
         col="red",
         main="Global Active Power",
         xlab="Global Active Power (kilowatts)")
    if (to.png==T)
        dev.off()
}

twodays <- prepare.data()
draw.plot.1()
