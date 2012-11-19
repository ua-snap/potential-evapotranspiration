################################################################################
#This file uses the function calcRl.r to calculate net longwave radiation in the
#outgoing direction for a monthly time series.
#It is a function of shortwave radiation, Tmax, Tmin and elevation.  As a result
#longwave radiation is 0 if Rs is 0.
#This script produces a geotiff of Rl for each month and year.
################################################################################

#PLEASE READ THE INTERNAL DOCUMENTATION IN calcRl.r FOR MORE INFORMATION ON THE CALCULATION

#SET THE WORKING DIRECTORY
setwd('WORKING DIRECTORY')

#ADD THE FUNCTION calcRl.r
source('/PATH2FUNCTION/calcRl.r')

#READ IN THE FILE THAT CONTAINS INFORMATION ABOUT z, ELEVATION
#skip=6: This skips the first 6 lines of header that provide basic metadata for the data (# rows, # cols, xllcorner, yll corner cellsize, and the no data value)
#na.strings = '-9999": this defines the missing value -9999 as NA, for easier indexing
z <- as.matrix(read.table('/Volumes/SMCAFEE2/PRISM/ak_dem_2k.txt',skip=6,na.strings='-9999'))

#FIND THE SIZE OF THE Z MATRIX -- NEEDED TO PREALLOCATE SUBSEQUENT MATRICES 
nrow <- nrow(z)  #1320
ncol <- ncol(z)  #2015

#DEFINE A VECTOR OF MONTH DESIGNATIONS FOR READING IN FILES AND NAMING OUTPUT FILES
month <- c(1:12)

#DEFINE A VECTOR OF YEARS FOR READING IN FILES AND NAMING OUTPUT FILES 
year <- c(1901:2006)
nyr <- length(year) #calculate number of years to loop over

#RUN THE FUNCTION, READING IN FILES AS NEEDED AND SAVING OUTPUT TO TEXT FILES
for (m in 11:12) { #month loop
  #Read in Ra and Rs for month m
  ra <- as.matrix(raster(paste('/PATH2Ra.DATA/ak_Ra_',month[m],'.tif',sep='')))
   rs <- as.matrix(raster(paste('/PATH2Rs.DATA/ak_Rs_',month[m],'.tif',sep='')))
    for (y in 1:nyr) { #year loop
      #Read in Tave for month m and year y
      tave<-as.matrix(read.table(paste('/PATH2TAVE.DATA/ak.cru.temp.',month[m],'.',year[y],'.txt',sep=''),skip=6,na.strings='-9999'))
      #Pre-allocate a matrix for Rl
      rl <- matrix(NA,nrow,ncol)
      #Run the function               
      rl <- calcRl(ra,rs,tave,z,nrow,ncol)
      rl <- round(rl,3)
      #Set up geotiff file to take output
      out <- raster(rl,xmn=-2301787.7731349,xmx= 1728212.22687, ymn = 108069.78588, ymx = 2748069.78588, crs = '+proj=aea +lat_1=55 +lat_2=65 +lat_0=50 +lon_0=-154 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs')
      writeRaster(out,filename=paste('ak_Rl_',month[m],'_',year[y],'.tif',sep=''),format = 'GTiff',options='COMPRESS=LZW',datatype='FLT4S',overwrite=T)
      rm(rl,tave,out) #clean up  files that are new for each year and year
    } #close the year loop
  rm(ra,rs) #clear up files used for each month
} # close the month loop