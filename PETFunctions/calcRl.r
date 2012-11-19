################################################################################
#This function calculates net longwave radiation in the outgoing direction as a 
#function of Tave, Ra, Rs and elevation (z).   
#NB Shuttleworth defines this equation as Rl = -fesT^4 where T is in deg K; we 
#leave off the minus sign to maintain the outgoing orientation on radiation 
#which allows us to use Rn = (1-albedo)*Rs - Rl
#NB: elevation should be in meters and temperatures in degC.
#Although this function produces several variables only Rl is returned.
#Source: Shuttleworth (U. Arizona Hydroclimatology Notes, Autumn 2004)
################################################################################

calcRl <- function(Ra,Rs,tave,z,nrow,ncol) { #what follows is the function
	
#Pre-allocate the Rcs matrix
Rcs <- matrix(NA,nrow,ncol)

#Calculate clear-sky shortwave radiation
#When Ra is 0, so is Rcs.  This leads to problems in calculating f (f is infinite), because it is a function of 1/Rcs.  If f is infinite, Rl is not calculated for any grid cell in which Ra is 0, leading to our not calculating PET for the northern 1/4 of the state.  To avoid this problem, replace Ra equal to 0 with 0.0001.  Note that this should lead to a f equal to 0, because if Rcs is 0, so is Rs.

Ra[Ra == 0] = 0.001
#NB this is less than the minimum Ra value in January (0.003)

Rcs[!is.na(z)] <- (0.75+(2e-5*z[!is.na(z)]))*Ra[!is.na(z)]

#Pre-allocate the f (cloud factor) matrix
f <- matrix(NA,nrow,ncol)

#Calculate the cloud factor
#Note that we use the cloud factor equation for humid areas, which is reasonable since relative humidity rarely falls <40% (http://climate.gi.alaska.edu/Climate/Humidity/index.html)
f[!is.na(z)] <- Rs[!is.na(z)]/Rcs[!is.na(z)]


#Pre-allocate the e (emissivity) matrix
em <- matrix(NA,nrow,ncol)

#Calculate emissivity
em[!is.na(z)] <- -0.02+0.261*exp(-0.000777*(tave[!is.na(z)]^2))

#Pre-allocate the Rl matrix
Rl <- matrix(NA,nrow,ncol)

#Put this all together to calculate Rl (outgoing)
#4.903 10^-9 MJ K-4 m-2 day-1 is the Stefan-Boltzmann constant
Rl[!is.na(z)] <- (4.903e-9)*f[!is.na(z)]*em[!is.na(z)]*((tave[!is.na(z)]+273)^4)
return(Rl)
} #this closes the function