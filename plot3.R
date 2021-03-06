# plot3() function:  creates Exporatory Data Analysis Project 1 plot3.png file

#Usage: 
# plot3()         -- generates plot1 in plot1.png file in working directory. 
#                   First downloads project data file from:
#                   https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
#                   Then unzips .txt file to temp file and does read.table to produce big data frame "df."
#                   Next subsets df to produce small data frame "dfx", and generates plot.
# dfx <- plot3()   -- same as above, but returns dataframe named "dfx" which can be used in subsequent 
#                  runs of the plotx() functions to save the initial download, read.table and subsetting steps.
# plot3(dfx)       -- if any plotx() function has been run with results assigned to dfx, the current
#                  run will use that previously created data frame and run 100x faster


plot3 <- function(dfx) {
  
  if (missing(dfx) || !is.data.frame(dfx)) {
    
    temp <- tempfile()
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
    df <- read.table(unz(temp, "household_power_consumption.txt"),header=T, sep=";", na.strings="?", 
                     nrows = 0, colClasses=c(rep("character",2), rep("numeric",7)) )
    unlink(temp)
    
    
    # Subset the big data frame to keep just the 2 days of interest, and
    # create new DateTime column of class "POSIXlt" from original Date and Time character cols
    
    
    dfx = df[df$Date %in% c("1/2/2007","2/2/2007"),]
    
    rm(df)
    
    dfx$DateTime <- strptime(paste(dfx[,1], dfx[,2]), format="%d/%m/%Y %T")
    
  }
  
  # generate the plot in "plot3.png" in the working directory.
  # Eliminate x-axis label and specify line-only plot (no points)
  
  # Make sure devices other than default are off
  if (length(dev.list() > 0)) dev.off(which = 2)
  
  if (file.exists("plot3.png")) file.remove("plot3.png")
  # Put colors in a vector to avoid mix-up between color asssignments for lines and legend
  colors = c("gray30","red","dodgerblue3")
  png(filename="plot3.png")
  with(dfx, plot(DateTime, Sub_metering_1, type="l", col=colors[1], xlab="",
                 ylab="Energy sub metering"))
  with(dfx, lines(DateTime, Sub_metering_2, type="l", col=colors[2]))
  with(dfx, lines(DateTime, Sub_metering_3, type="l", col=colors[3]))
  legend("topright", col=colors, lty=1, legend=names(dfx)[7:9])       
  dev.off()
  
  #Cause data frame dfx to be returned, but doesn't try to print it if no
  #assignment of the return to an object is specified
  
  dfx = dfx
  
}