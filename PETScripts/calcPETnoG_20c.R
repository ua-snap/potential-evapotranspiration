###########################################################################
#This file uses the function calcPET.r to calculate potential evapotranspriation via the Priestley-Taylor equation.
#It is a function of net radiation, ground heat flux, the saturation vapor pressure and a proportionality coefficient (α).  PET is set to 0 if it is negative.
#This script produces a geotiff of PET for each month and year.
#NB: Values in this text file are average monthly PET in terms of mm/day.  Values
#must be multiplied by the number of days per month to get cumulative monthly PET.
###########################################################################

#PLEASE READ THE INTERNAL DOCUMENTATION IN calcPET.r FOR MORE INFORMATION ON THE CALCULATION

#SET THE WORKING DIRECTORY
setwd('WORKINGDIRECTORY')

#ADD THE FUNCTION calcPET.r
source('/PATH2FUNCTION/calcPET.r')

#FIND THE SIZE OF THE MATRIX -- WILL NEED THESE TO PRE-ALLOCATE SUBSEQUENT MATRICES
nrow <- 1320
ncol <- 2015

# DEFINE A VECTOR OF MONTH DESIGNATIONS FOR READING IN FILES AND NAMING OUTPUT FILES
month <- c(1:12)

#DEFINE A VECTOR OF YEARS FOR READING IN FILES AND NAMING OUTPUT FILES 
year <- c(1901:2006)
nyr <- length(year) #calculate number of years to loop over

    		
#RUN THE FUNCTION, READING IN FILES AS NEEDED AND SAVING OUTPUT TO TEXT FILES
for (m in 1:12) { #month loop
  	for (y in 1:nyr) { #year loop
		    #Read in SG, Rn, and G for month m and year y
    		sg <- as.matrix(raster(paste('/PATH2SG.DATA/cru/ak_SG_',month[m],'_',year[y],'.tif',sep='')))
    		rn <- as.matrix(raster(paste('/PATH2Rn.DATA/cru/ak_Rn_',month[m],'_',year[y],'.tif',sep=''))) 
    		g <- as.matrix(raster(paste('/PATH2G.DATA/cru/ak_G_',month[m],'_',year[y],'.tif',sep='')))
    		g[!is.na(g)] <-0
    		#Pre-allocate PET matrix to hold monthly average rate in mm/day 
        pet <- matrix(NA,nrow,ncol)
		    #Run calcPET.r to calculate daily average PET for month m
    		pet <- calcPET(sg,rn,g,nrow,ncol)
	    	pet <- round(pet,2)
        #Write the data to a geotiff
        out <- raster(pet,xmn=-2301787.7731349,xmx= 1728212.22687, ymn = 108069.78588, ymx = 2748069.78588, crs = '+proj=aea +lat_1=55 +lat_2=65 +lat_0=50 +lon_0=-154 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs')
        writeRaster(out,filename=paste('ak_PETnoG_',month[m],'_',year[y],'.tif',sep=''),format = 'GTiff',options='COMPRESS=LZW',datatype='FLT4S',overwrite=T)
        rm(sg,rn,pet,out) #clean up files used for month m and year y
	} #close the year loop
} # close the month loop