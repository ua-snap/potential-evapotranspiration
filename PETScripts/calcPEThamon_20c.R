###########################################################################
#This file uses the function calcPEThamon.r to calculate potential evapotranspriation via the Hamon equation.
#It is a function of net radiation, ground heat flux, the saturation vapor pressure and a proportionality coefficient (α).  PET is set to 0 if it is negative.
#This script produces a geotiff of PET for each month and year.
#NB: Values in this text file are average monthly PET in terms of mm/day.  Values
#must be multiplied by the number of days per month to get cumulative monthly PET.
###########################################################################

#PLEASE READ THE INTERNAL DOCUMENTATION IN calcPEThamon.r FOR MORE INFORMATION ON THE CALCULATION

#SET THE WORKING DIRECTORYhamon
setwd('/WORKING DIRECTORY')

#ADD THE FUNCTION calcPEThamon.r
source('/PATH2FUNCTION/calcPEThamon.r')

#SPECIFY THE SIZE OF THE MATRIX -- WILL NEED THESE TO PRE-ALLOCATE SUBSEQUENT MATRICES
nrow <- 1320
ncol <- 2015

# DEFINE A VECTOR OF MONTH DESIGNATIONS FOR READING IN FILES AND NAMING OUTPUT FILES
month <- c(1:12)

#DEFINE A VECTOR OF YEARS FOR READING IN FILES AND NAMING OUTPUT FILES 
year <- c(1901:2006)
nyr <- length(year) #calculate number of years to loop over


#This version of the file calculates N for each day within the month and then averages daily day length to get a monthly value, rather than using a "representative" day.
for (m in 1:12) {  #month loop
	#Read in N data for each month
	N = as.matrix(raster(paste('PATH2N.DATA/ak_N_',month[m],'.tif',sep='')))
	#Read in Tave data for each year/month
  	for (y in 1:nyr) { #year loop
  		#skip=6 does not import the first 6 rows of the temperature files, which contain metadata
    	#na.strings='-9999' replaces -9999 with NA for easier indexing
    	tave<-as.matrix(read.table(paste('/PATH2TAVE.DATA/ak.cru.temp.',month[m],'.',year[y],'.txt',sep=''),skip=6,na.strings='-9999'))
    	#Pre-allocate the pet matrix
    	pet <- matrix(NA,nrow,ncol)
    #Run the function to calculate PET as a function of day length and averate temperature
    	pet <- calcPEThamon(N,tave,nrow,ncol)
		pet <- round(pet,2)
        #Write the data to a geotiff
        out <- raster(pet,xmn=-2301787.7731349,xmx= 1728212.22687, ymn = 108069.78588, ymx = 2748069.78588, crs = '+proj=aea +lat_1=55 +lat_2=65 +lat_0=50 +lon_0=-154 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs')
        writeRaster(out,filename=paste('ak_PEThamon_',month[m],'_',year[y],'.tif',sep=''),format = 'GTiff',options='COMPRESS=LZW',datatype='FLT4S',overwrite=T)
        rm(pet,out) #clean up files used for month m and year y
	} #close the year loop
	rm(N)#clean up the files used for all years of month m
} # close the month loop