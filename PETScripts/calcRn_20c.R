################################################################################
#This file uses the function calcRn.r to calculate net radiation for a monthly
#time series.  It uses albedo, shortwave radiation and net longwave radiation
#in the outgoing direction.
#It then produces a geotiff of Rn for each month and year.
################################################################################

#PLEASE READ THE INTERNAL DOCUMENTATION IN calcRn.r FOR MORE INFORMATION ON THE CALCULATION

#SET THE WORKING DIRECTORY
setwd('/WORKING DIRECTORY')

#ADD THE FUNCTION calcRn.r
source('/PATH2FUNCTION/calcRn.r')

#READ IN THE FILE THAT CONTAINS INFORMATION ABOUT ALBEDO
#skip=6: This skips the first 6 lines of header that provide basic metadata for the data (# rows, # cols, xllcorner, yll corner cellsize, and the no data value)
#na.strings = '-9999"; this defines the missing value -9999 as NA, for easier indexing
albedo <- as.matrix(read.table('/PATH2ALBEDO/reveg_pet_albedo_final.txt',skip=6,na.strings='-9999'))

#DETERMINE THE SIZE OF THE ALBEDO MATRIX -- WILL NEED THESE TO PRE-ALLOCATE SUBSEQUENT MATRICES
nrow <- nrow(albedo)  #1320
ncol <- ncol(albedo)  #2015

#DEFINE A VECTOR OF MONTH DESIGNATIONS FOR READING IN FILES AND NAMING OUTPUT FILES
month<-c(1:12)

#DEFINE A VECTOR OF YEARS FOR READING IN FILES AND NAMING OUTPUT FILES 
year <- c(1901:2006) 
nyr <- length(year) #calculate number of years to loop over

#RUN THE FUNCTION, READING IN FILES AS NEEDED AND SAVING OUTPUT TO TEXT FILES
for (m in 7:12) { #month loop
	#Read in Rs for month m
	rs<-as.matrix(raster(paste('/PATH2/Rs.DATA/ak_Rs_',month[m],'.tif',sep='')))
  for (y in 1:nyr) { #year loop	
    #Read in Rl for month m and year y
    rl<-as.matrix(raster(paste('/PATH2Rl.DATA/cru/ak_Rl_',month[m],'_',year[y],'.tif',sep=''))) 
    #Pre-allocate a matrix for Rn
    rn <- matrix(NA,nrow,ncol)
    #Run the function
    rn <- calcRn(albedo,rs,rl,nrow,ncol)
    rn <- round(rn,3)
    #Write data to a geotiff file
    out <- raster(rn,xmn=-2301787.7731349,xmx= 1728212.22687, ymn = 108069.78588, ymx = 2748069.78588, crs = '+proj=aea +lat_1=55 +lat_2=65 +lat_0=50 +lon_0=-154 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs')
    writeRaster(out,filename=paste('ak_Rn_',month[m],'_',year[y],'.tif',sep=''),format = 'GTiff',options='COMPRESS=LZW',datatype='FLT4S',overwrite=T)
    rm(rl,out,rn) #clean up  files that will be regenerated
  } #close the year loop
  rm(rs)
} # close the month loop