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

##Plot 1 is a histogram of global active power with bars in red and 
##12 bins; save to PNG file with dimensions of 480x480 pixels
hist(power$Global_active_power, col = "red", breaks = 12, xlab = 
       "Global Active Power (kilowatts)", ylab = "Frequency", main = 
       "Global Active Power")
dev.copy(png, file="plot1.png", width=480, height=480)
dev.off()
