################################################################################
#This function calculates daylength for deriving PET via the Hamon (1963) 
#equation as described in Lu et al. (2005).
#It is calculated for each day of the year and then averaged over months.
#NB: Latitude should be in radians (not degrees).
#NB: Non-real values are produces for w (sunset hour angle) at times of the year
#and at latitudes where the sun never rises or sets. However, it makes sense to
#use just the real portion of the value, as it sets w to 0 in the winter and pi
#in the summer. This translates into N of 0 and 24, respectively

################################################################################

calcN <- function(jd,lat,nrow,ncol) {  #what follows is part of the function

#Calculate declination, a function of Julian day.  It is a single value for each day.
dc <- 0.409*sin(((2*pi/365)*jd)-1.39)

#Pre-allocate the sunset hour angle (w) matrix
w <- matrix(NA,nrow,ncol)

#Calculate the sunset hour angle, a function of latitude and declination. Note that at v. high latitudes, this function can produce non-real values.  
w[!is.na(lat)] <- as.matrix(Re(acos(as.complex(-1*tan(dc)*tan(lat[!is.na(lat)])))))

#Pre-allocate the daylength matrix
N <- matrix(NA,nrow,ncol)

#Calculate N from the sunset hour angle
N[!is.na(lat)] <- (24/pi)*w[!is.na(lat)]

return(N)
} #this closes the function