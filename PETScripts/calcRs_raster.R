################################################################################
#This file uses the function calcRs.r to calculate incoming solar radiation at
#the ground surface for a monthly time series.  
#It requires the use of Tmax, Tmin and total solar radiation at the top of the 
#atmosphere (Ra), as well as the Hargreaves coefficient (k).
#This script produces a geotiff of Rs for each month.  Because Rs is a functino of the difference between Tmax and Tmin, which remains constant in these equations, Rs need only be calculated once for each month.
################################################################################

#PLEASE READ THE INTERNAL DOCUMENTATION IN calcRs.r FOR MORE INFORMATION ON THE CALCULATION

#SET THE WORKING DIRECTORY
setwd('WORKING DIRECTORY')

#ADD THE FUNCTION calcRs.r
source('/PATH2FUCNTION/calcRs.r')

#READ IN THE FILE THAT CONTAINS INFORMATION ABOUT k, THE HARGREAVES COEFFICIENT 
#skip=6: This skips the first 6 lines of header that provide some basic metadata for the data (# rows, # cols, xllcorner, yll corner cellsize,a nd the no data value)
#na.strings = '-9999"; this defines the value -9999 as NA for easier indexing
k <- as.matrix(read.table('PATH2HARGREAVESk/airmass_final.txt',skip=6,na.strings = '-9999'))

#FIND THE SIZE OF THE K MATRIX -- WILL NEED THESE TO SET UP SUBSEQUENT MATRICES 
nrow<-nrow(k)  #1320
ncol<-ncol(k)  #2015

#DEFINE A VECTOR OF MONTH DESIGNATIONS FOR READING IN FILES AND NAMING OUTPUT FILES
month <- c(1:12)


#RUN THE FUNCTION, READING IN FILES AS NEEDED AND SAVING OUTPUT TO TEXT FILES
for (m in 1:12) { #month loop
  #Read in Ra files for month m -- these are constant across years
  ra<-as.matrix(raster(paste('/PATH2Ra.DATA/ak_Ra_',month[m],'.tif',sep='')))
  #Read in Tmax and Tmin for month m in the PRISM dataset
  #skip=6 skips the first 6 lines of the file, which are metadata; na.strings indicates that a value of -9999 in the file should indicate no value.
  #PRISM stores data as 10* degrees C, so data must be multiplied by 0.1 before they can be used
      tmax<-0.1*as.matrix(read.table(paste('/PATH2TMAX.DATA/ak_tmax_',month[m],'.asc',sep=''),skip=6,na.strings = -9999))
      tmin<-0.1*as.matrix(read.table(paste('/PATH2TMIN.DATA/ak_tmin_',month[m],'.asc',sep=''),skip=6,na.strings = -9999))
      #pre-allocate the rs matrix
      rs<-matrix(NA,nrow,ncol)
      #Run the function calcRs
      rs <- calcRs(k,ra,tmax,tmin,nrow,ncol)
	  rs <- round(rs,3)
      #Set up geotiff file to take Rs of month m and year y
      out <- raster(rs,xmn=-2301787.7731349,xmx= 1728212.22687, ymn = 108069.78588, ymx = 2748069.78588, crs = '+proj=aea +lat_1=55 +lat_2=65 +lat_0=50 +lon_0=-154 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs')
      #Write Rs to the geotiff file
writeRaster(out,filename=paste('ak_Rs_',month[m],'.tif',sep=''),format = 'GTiff',options='COMPRESS=LZW',datatype='FLT4S',overwrite=T)
      rm(rs,ra,out)  #delete files that will be regenerated for the next month
} #close month loop
