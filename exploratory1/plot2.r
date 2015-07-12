source("./src/functions.r")             # functions needed to download and process original data

draw.plot.2 <- function(to.png=T) {
    if (to.png==T)
        png("plot2.png")
    plot(twodays$DateTime,
         twodays$Global_active_power,
         type="l",
         ylab = "Global Active Power (kilowatts)",xlab="")
    if (to.png==T)
        dev.off()
}

twodays <- prepare.data()               # to get two days' data for the plot
draw.plot.2()
