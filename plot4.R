
## This code creates a png file of four time series plots of data from 
## 2007/02/01 to 2007/02/02 from the UCI data set at 
## https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption

## Plots are (clockwise from top left)
## Global active power, Voltage, Global reactive power, Sub metering (1,2,3), 

## Plot file is plot4.png

## Author : Michael Hunt


##Include the correct pathname in setwd and set the wd to ExData_Plotting1
##setwd("pathname/ExData_Plotting1")

##Create csv file of subset required in ./data directory - or skip if already there.

#create sub-directory of the working dir called "data" if one does not exist already

if(!file.exists("data")){
        dir.create("data")
}

#if data subset not already downloaded and in csv file,
#download it and subset it into data.frame df.

#if csv of data subset already exists in ./data,download it into data.frame df
if(file.exists("./data/df.csv")){
        print("data subset already in ./data directory")
        df<-read.table("./data/df.csv",
                       sep=",",
                       header=T,
                       na.strings="?",
                       stringsAsFactors=FALSE)
        df$dd<-as.POSIXct(df$dd)
}        
if(!file.exists("./data/df.csv")){
        ##download data from UCI website into csv file
        print("downloading data from UCI site")
        temp<-tempfile()
        fileURL<-"https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
        download.file(fileURL,temp, mode="wb")
        unzip(temp, "household_power_consumption.txt")
        file.rename(from="household_power_consumption.txt",to="./data/household_power_consumption.csv")
        
        ##read data from csv file into data frame DF
        DF<-read.table("./data/household_power_consumption.csv",
                       sep=";",
                       header=T,
                       na.strings="?",
                       stringsAsFactors=FALSE)
        
        #convert date column to POSIXlt
        DF$Date<-as.Date(DF$Date,format="%d/%m/%Y")
        #subset to the two days we want
        df<-subset(DF,DF$Date == "2007-02-01" | DF$Date == "2007-02-02")
        dd<-paste(df$Date,df$Time)
        dd<-as.POSIXct(dd)
        df<-data.frame(dd,df,stringsAsFactors=FALSE)
        #write data subset to csv file in ./data folder. Use this from now on
        write.csv(df,file="./data/df.csv")
        print("data subset in ./data/df.csv")
}

##Create plot4 in png file

#open png device;create "plot4.png" in working directory
png("plot4.png")
#create plot and send to the file

par(mfrow=c(2,2))

x<-df$dd

#top left plot - Global active power
y<-df$Global_active_power
plot(x,y,
     type="l",
     xlab="",
     ylab="Global Active Power (kilowatts)")

#top right plot - Voltage
y<-df$Voltage
plot(x,y,
     type="l",
     xlab="datetime",
     ylab="Voltage")
points(x,y,type="l")

#bottom left plot - Energy sub metering
y1<-df$Sub_metering_1
y2<-df$Sub_metering_2
y3<-df$Sub_metering_3
plot(x,y1,
     type="l",
     xlab="",
     ylab="Energy sub metering")
points(x,y2,type="l",col="red")
points(x,y3,type="l",col="blue")
legend("topright",
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       bty="n",
       lty=c(1,1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5,2.5),
       col=c("black","blue","red"),
       cex=0.95
       )
#bottom right plot - Global reactive power
y<-df$Global_reactive_power
plot(x,y,
     #type="l",
     lwd=0.1,
     pch=20,
     cex=0.5,
     xlab="datetime",
     ylab="Global_reactive_power")
points(x,y,type="l")
dev.off() # close the png file device
