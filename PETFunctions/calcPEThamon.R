################################################################################
#This function calculates PET via the Hamon (1963) equation
#It can be calculated for each month, based on average day length using only 
#average monthly temperature for measured variables.
#Tave should be in degrees Celcius
#Daylength should be in hours.
#Source: Lu et al. (2005)
################################################################################

calcPEThamon <- function(N,Tave, nrow,ncol) {  #what follows is part of the function

#Calculate esat
esat <- matrix(NA,nrow,ncol)
esat[!is.na(N)] <- 6.108*exp(17.27*Tave[!is.na(N)]/(Tave[!is.na(N)]+237.3))

#Calculate PET
PET <- matrix(NA,nrow,ncol)
PET[!is.na(N)] <- 0.1651*216.7*(N[!is.na(N)]/12)*(esat[!is.na(N)]/(Tave[!is.na(N)]+273.3))

return(PET)
}