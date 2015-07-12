file.head <- function(path.to.file,nlines=5)
    {
        con <- file(path.to.file, "rt")
        n.lines <- readLines(con, nlines)
        print(n.lines)
        rm(con)
    }

zipped.file.head <- function(path.to.zfile,zpath.to.file,nlines=5)
    {
        data <- unz(path.to.zfile, zpath.to.file)
        print(readLines(data,n=nlines))
        rm(data)
    }

get.the.file <- function(fileUrl,file.dest)
{
    ## for hard copy
    download.file(fileUrl,destfile=file.dest,method="curl")
    ##zipped.file.head(file.dest,dat.file)
}

get.full.dataframe2 <- function(file.dest,dat.file)
    {
        tdata <- read.table(unz(file.dest,dat.file),
                            header=T,sep=";",
                            na.strings="?",
                            stringsAsFactors=F)
        return(tdata)
    }

## some examination
## str(tdata)
## length(names(tdata))                    # should be nine
## head(tdata)$Date
## tail(tdata)$Date

get.filtered.data <- function(tdata)
    {
        ## getting only 2007-02-01 and 2007-02-02
        library(dplyr)
        ##names(tdata)
        twodays <- filter(tdata,Date=="1/2/2007" | Date=="2/2/2007")
        ##str(twodays)
        rm(tdata)
        ##str(twodays.bak)
        return(twodays)
    }

transform.dates <- function(twodays,saved.twodays)
    {
        ## date and time conversion
        library(lubridate)
        twodays.bak = twodays
        ## dmy(twodays[1,1])
        ## dmy(twodays[nrow(twodays),1])
        ## dmy(head(twodays)$Date)
        twodays$Date = dmy(twodays$Date)
        ## head(twodays)$Time
        ## hms(head(twodays)$Time)
        twodays$Time = hms(twodays$Time)
        ## str(twodays)
        ## head(twodays)$Time # looks a little strange because of the zero hours
        ## tail(twodays)$Time   # looks quite normal
        twodays$DateTime = dmy_hms(paste(twodays.bak$Date,twodays.bak$Time))
        save(twodays.bak,file="./data/twodays.bak")
        rm(twodays.bak)
        save(twodays,file=saved.twodays)
        rm(twodays)
        load(saved.twodays)
        ##names(twodays)
        return(twodays)
    }

get.twodays <- function(file.dest,file.path,saved.twodays)
    {
        full.data <- get.full.dataframe2(file.dest,file.path)
        filtered.data <- get.filtered.data(full.data)
        twodays <- transform.dates(filtered.data,saved.twodays)
        return(twodays)
    }

## plots
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
    draw.plot.2(to.png=F)
    draw.voltage()
    draw.plot.3(to.png=F)
    draw.reactive()
    par(mfrow=c(1,1))
    dev.off()
}

prepare.data <- function()
    {
        data.dir <- file.path("./data")
        if(!file.exists(data.dir))
            dir.create(data.dir)
        saved.twodays = "./data/twodays.save"
        
        if(!exists("twodays"))
            {
                if(file.exists(saved.twodays))
                    {
                        load(saved.twodays)
                    }
                else
                    {
                        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
                        file.dest <- file.path("./data/hpc.zip")
                        dat.file <- file.path("household_power_consumption.txt")
                        
                        if (!file.exists(file.dest))
                            get.the.file(fileUrl,file.dest)
                        twodays <- get.twodays(file.dest,dat.file,saved.twodays)
                    }
            }
        return(twodays)
    }