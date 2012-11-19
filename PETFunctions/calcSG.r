################################################################################
#This calculates the quantity s/(s+gamma) -- the slope of the saturation vapor
#pressure curve over the sum of the saturation vapor pressure curve and the 
#psychrometric constant -- as a function of monthly Tave (Rouse and Stewart, 
#1972; Stewart and Rouse, 1976).
#This approximation is appropriate for tundra and boreal forest (Rouse et al.
#1977 in Kane et al. 1990), but there are questions about how valid the 
#calculation will be in high alpine environments, south of the Alaska Range,
#and in southeast Alaska.
#Temperature should be in degC
################################################################################

calcSG <- function(tave,nrow,ncol)  {  #function follows

#pre-allocate matrix
SG <- matrix(NA,nrow,ncol)

#Calculate SG
SG[!is.na(tave)] = 0.406 + 0.011*tave[!is.na(tave)]
return(SG)
} #close function