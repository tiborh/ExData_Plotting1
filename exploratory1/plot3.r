source("./src/functions.r")             # functions needed to download and process original data

draw.plot.3 <- function(to.png=T) {
    if (to.png==T)
        png("plot3.png")
    plot(twodays$DateTime,
         twodays$Sub_metering_1,
         type="l",ylab = "Energy sub metering",xlab="")
    points(twodays$DateTime,
           twodays$Sub_metering_2,
           col="red",type="l")
    points(twodays$DateTime,
           twodays$Sub_metering_3,
           col="blue",type="l")
    legend("topright",
           lwd=c(1.5,1.5,1.5),
           col=c("black","red","blue"),
           legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
    if (to.png==T)
        dev.off()
}

twodays <- prepare.data()               # to get two days' data for the plot
draw.plot.3()
