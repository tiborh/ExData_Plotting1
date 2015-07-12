source("./src/functions.r")
## all functions are included in functions.r
## below, they are repeated only to make peer evaluation easier

draw.voltage <- function() {
    plot(twodays$DateTime,
         twodays$Voltage,
         type="l",
         ylab = "Voltage",xlab="datetime")
}

draw.reactive <- function() {
    plot(twodays$DateTime,
         twodays$Global_reactive_power,
         type="l",
         ylab = "Global_reactive_power",xlab="datetime")
}

draw.plot.4 <- function() {
    png("plot4.png")
    par(mfrow=c(2,2))
    draw.plot.2(to.png=F)               # used from functions.r, same as in plot2.r
    draw.voltage()
    draw.plot.3(to.png=F)               # used from functions.r, same as in plot3.r
    draw.reactive()
    par(mfrow=c(1,1))
    dev.off()
}

twodays <- prepare.data()               # to get two days' data for the plot
draw.plot.4()
