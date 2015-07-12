source("./src/functions.r")             # functions needed to download and process original data

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

twodays <- prepare.data()               # to get two days' data for the plot
draw.plot.1()
