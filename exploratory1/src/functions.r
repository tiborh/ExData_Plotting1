## displays the first "nlines" of a file
file.head <- function(path.to.file,nlines=5)
    {
        con <- file(path.to.file, "rt")
        n.lines <- readLines(con, nlines)
        print(n.lines)
        rm(con)
    }

## displays the first "nlines" of a zipped file
zipped.file.head <- function(path.to.zfile,zpath.to.file,nlines=5)
    {
        data <- unz(path.to.zfile, zpath.to.file)
        print(readLines(data,n=nlines))
        rm(data)
    }

## a solution to download the file only temporarily (currently, unused path)
get.full.dataframe1 <- function(fileUrl,dat.file,file.dest)
    {
        ## for temp solution
        temp <- tempfile()
        download.file(fileUrl,temp,method="curl")
        tdata <- read.table(unz(temp, dat.file),header=T,sep=";",na.strings="?")
        unlink(temp)                            # throwing away data file
        return(tdata)
    }

## gets the data from the downloaded zip file
get.full.dataframe2 <- function(file.dest,dat.file)
    {
        tdata <- read.table(unz(file.dest,dat.file),
                            header=T,sep=";",
                            na.strings="?",
                            stringsAsFactors=F)
        return(tdata)
    }

## filter out only necessary data
get.filtered.data <- function(tdata)
    {
        ## getting only 2007-02-01 and 2007-02-02
        library(dplyr)
        twodays <- filter(tdata,Date=="1/2/2007" | Date=="2/2/2007")
        rm(tdata)
        return(twodays)
    }

## transforming date and time strings to date and time columns
transform.dates <- function(twodays,saved.twodays)
    {
        ## date and time conversion is done with lubridate functions
        ## you may need:
        ## install.packages("lubridate")
        library(lubridate)
        twodays.bak = twodays           # creating a backup copy
        twodays$Date = dmy(twodays$Date) # Date column converted to Date
        twodays$Time = hms(twodays$Time) # Time column converted into Time
        twodays$DateTime = dmy_hms(paste(twodays.bak$Date,twodays.bak$Time)) # a new column which is a combination of the Date and Time columns
        rm(twodays.bak)
        save(twodays,file=saved.twodays) # to create a cached variable for later use

        return(twodays)
    }

## gets two days' data from zipped file
get.twodays <- function(file.dest,file.path,saved.twodays)
    {
        full.data <- get.full.dataframe2(file.dest,file.path) # full data table is extracted
        filtered.data <- get.filtered.data(full.data)         # only the filtered data remains
        twodays <- transform.dates(filtered.data,saved.twodays) # date and time are transformed into formats to ease their use
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

## used in plot4
draw.voltage <- function() {
    plot(twodays$DateTime,
         twodays$Voltage,
         type="l",
         ylab = "Voltage",xlab="datetime")
}

## used in plot4
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

## prepares the data for the plots
prepare.data <- function()
    {
        saved.twodays = "./data/twodays.save" # path to cached data
        
        if(!exists("twodays"))
            {
                ## if cached data is available, use that
                if(file.exists(saved.twodays))
                    {
                        load(saved.twodays)
                    }
                else
                    {
                        data.dir <- file.path("./data")
                        ## create data dir if it does not exist
                        if(!file.exists(data.dir))
                            dir.create(data.dir)
                        ## get the paths right
                        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
                        file.dest <- file.path("./data/hpc.zip")
                        dat.file <- file.path("household_power_consumption.txt")

                        ## download zipped file if necessary
                        if (!file.exists(file.dest))
                            download.file(fileUrl,destfile=file.dest,method="curl")
                        ## get the two days' data in appropriate format
                        twodays <- get.twodays(file.dest,dat.file,saved.twodays)
                    }
            }
        return(twodays)
    }
