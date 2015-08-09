#Note - the code takes a LONG time to run and produce results
#but it works. Please be patient if you try to run this.


#Find out all days for which we need data
corrected_all_days <- grep('^1/2/2007|^2/2/2007',readLines("household_power_consumption.txt"))
df <- read.csv("household_power_consumption.txt", sep=";", nrows=1, skip=0, header=TRUE)

#Get the column names
data_col_names <- colnames(df)


#Now read in the rows which you need to and add them to the dataframe
for (i in corrected_all_days) {
        #print(i)
        new_row = read.csv("household_power_consumption.txt", sep=";", nrows=1, skip=i-1, header=FALSE, check.names = FALSE, col.names = data_col_names, na.strings="?")
        df <- rbind(df, new_row)
}
# Now delete the first row which we read in first and does not belong to the pattern
df <- df[-c(1),]        
write.table(df, file="revised_data_orig_filtered.txt", row.names = FALSE, sep=";")

#End of common reading code

df1 <-read.csv("revised_data_orig_filtered.txt", sep=";", header=TRUE)
png(df1, filename="plot3.png",width = 480, height = 480, units = "px")
#hist(df1$Global_active_power, xlab = "Global Active Power (kilowatts)", main = "Global Active Power", col = "red")
# df1[,1]<- as.Date(df1[, 1])
# df1[,2]<- as.Date(df1[, 2])
df1[,1]<- as.character(df1[, 1])
df1[,2]<- as.character(df1[, 2])
df1["datetime"] <- NA # That creates the new column named "datetime" filled with "NA"
#df1$datetime <- df1$Date + df1$Time  # As an example, the new column receives the result of C - D
df1$datetime <- paste(df1$Date, df1$Time)  # As an example, the new column receives the result of C - D

df1$datetime <- strptime(df1$datetime, "%d/%m/%Y %H:%M:%S")
#plot(df1$datetime, df1$Global_active_power, type = "l",ylab = "Global Active Power (kilowatts)", xlab = "")
#title(main=NULL, xlab = "Global Active Power (kilowatts)", ylab = NULL)



plot(df1$datetime, df1$Sub_metering_1, type="l", ylab = "Energy sub metering", xlab = "")
#plot(df1$datetime, df1$Sub_metering_2, type="l", ylab = "Energy sub metering", xlab = "", col = "red")
lines(df1$datetime, df1$Sub_metering_2, ylab = "Energy sub metering", xlab = "", col = "red")
lines(df1$datetime, df1$Sub_metering_3, ylab = "Energy sub metering", xlab = "", col = "blue")
#legend("topright", legend ="Data")
legend('topright', names(df1)[c(7,8,9)] , lty=1, col=c('black', 'red', 'blue'), bty='o', cex=.75)
dev.off()