##Download file, unzip, and read file
if(!file.exists(".ExDataWk1")){dir.create("./ExDataWk1")}
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "household_power_consumption.zip")
temp <- unzip(zipfile = "household_power_consumption.zip", exdir = "./ExDataWk1")
UCI <- read.table(temp, header = TRUE, sep = ";")

##Convert Date variable into date class and then subset for the two-day
##period of interest for this analysis
UCI$Date <- as.Date(UCI$Date, format="%d/%m/%Y")
power <- UCI[(UCI$Date == "2007-02-01") | (UCI$Date == "2007-02-02"), ]

##Add a new date-time variable
power <- transform(power, timestamp = as.POSIXct(paste(Date, Time)), 
                   "%d/%m/%Y %H:%M:%S")

##Convert remaining variables to numeric class
power$Global_active_power <- as.numeric(as.character(power$Global_active_power))
power$Global_reactive_power <- as.numeric(as.character(power$Global_reactive_power))
power$Voltage <- as.numeric(as.character(power$Voltage))
power$Sub_metering_1 <- as.numeric(as.character(power$Sub_metering_1))
power$Sub_metering_2 <- as.numeric(as.character(power$Sub_metering_2))
power$Sub_metering_3 <- as.numeric(as.character(power$Sub_metering_3))

##Plot contains 4 panels grpahing 1-Global Active Power;
##2-Voltage; 3-Energy sub metering (by type, w/ legend); and
##4-Global_reactive_power, all over time (NOTE: #1 replicates Plot2, 
##and #3 replicates Plot3)
##Plots 2 and 4 (moving across rows) are labeled on x axis with
##'datetime'; plots 1/3 have no xlab; no main label
##Save to PNG file with dimensions of 480x480 pixels
par(mfrow = c(2,2), mar = c(4,4,1,1))
plot(power$timestamp, power$Global_active_power, type = "l", xlab = "", ylab = 
       "Global Active Power")
plot(power$timestamp, power$Voltage, type = "l", xlab = "datetime", 
     ylab = "Voltage")
plot(power$timestamp, power$Sub_metering_1, type = "l", xlab = "", ylab = 
       "Energy sub metering")
lines(power$timestamp, power$Sub_metering_2, col = "red")
lines(power$timestamp, power$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), legend = 
         c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = 1)
plot(power$timestamp, power$Global_reactive_power, type = "l", 
     xlab = "datetime", ylab = "Global_reactive_power")
dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()
