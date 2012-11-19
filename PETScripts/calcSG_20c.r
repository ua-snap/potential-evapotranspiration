################################################################################
#This files uses the function calcSG.r to calculate s/(s+gamma) as a function
#of Tave for a monthly time series.
#It produces a geotiff of s/(s+g) for each month and year.
#NB: Temperatures are in degC.
################################################################################

#PLEASE READ THE INTERNAL DOCUMENTATION IN calcSG.r FOR MORE INFORMATION ON THE CALCULATION

#SET THE WORKING DIRECTORY
setwd('WORKING DIRECTORY')

#ADD THE FUNCTION calcSG.r
source('/PATH2FUNCTION/calcSG.r')

#DEFINE THE NUMBER OF ROWS AND COLUMNS
nrow <- 1320
ncol <- 2015

#DEFINE A VECTOR OF MONTH DESIGNATIONS FOR READING IN FILES AND NAMING OUTPUT FILES
month <- c(1:12)

#DEFINE A VECTOR OF YEARS FOR READING IN FILES AND NAMING OUTPUT FILES 
year <- c(1901:2006) 
nyr <- length(year) #calculate number of years to loop over

#RUN THE FUNCTION, READING IN FILES AS NEEDED AND SAVING OUTPUT TO TEXT FILES
for (m in 1:12) { #month loop
  for (y in 1:nyr) { #year loop
    #Read in Tave for month m and year y
    #skip=6 does not import the first 6 rows of the temperature files, which contain metadata
    #na.strings='-9999' replaces -9999 with NA for easier indexing
    tave<-as.matrix(read.table(paste('/PATH2TAVE.DATA/ak.cru.temp.',month[m],'.',year[y],'.txt',sep=''),skip=6,na.strings='-9999'))
    sg <- matrix(NA,nrow,ncol)
    #Run the function calcSG
    sg <- calcSG(tave,nrow,ncol)
    sg <- round(sg,3)
    #Write SG for month m and year y to a geotiff file
    out <- raster(sg,xmn=-2301787.7731349,xmx= 1728212.22687, ymn = 108069.78588, ymx = 2748069.78588, crs = '+proj=aea +lat_1=55 +lat_2=65 +lat_0=50 +lon_0=-154 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs')
    writeRaster(out,filename=paste('ak_SG_',month[m],'_',year[y],'.tif',sep=''),format = 'GTiff',options='COMPRESS=LZW',datatype='FLT4S',overwrite=T)
    rm(sg,tave,out) #clean up variables used by month m and year y
  } #close the year loop
} # close the month loop