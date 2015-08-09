#Note - the code takes a LONG time to run and produce results
#but it works. Please be patient if you try to run this.


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
df1 <-read.csv("revised_data_orig_filtered.txt", sep=";", header=TRUE)


png(df1, filename="plot1.png",width = 480, height = 480, units = "px")
hist(df1$Global_active_power, xlab = "Global Active Power (kilowatts)", main = "Global Active Power", col = "red")
dev.off()
