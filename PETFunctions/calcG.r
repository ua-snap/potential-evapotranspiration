################################################################################
#This function estimates ground heat flux as a function of average air temperature.
#The equation was based on growing season (May-September) air temperature and 
#ground heat flux data collected at stations in Alaska and compiled by Bob Bolton.  
#Stations used included Upper and Middle Kuparok (North Slope), Council Blueberrry,
# Council C1, Kougarok K1, Kougarok K2, and Kougaruk K3 (Seward Peninsula), and
# ?? number of sites from the interior.  Five points from the Middle Kuparok site
#were dropped because they were very different from others (compare all_chart and
#drop5 chart  in all_Qgrnd.xlsx)
#Ground heat flux is set to 0 when average temperature is set to 0 for 3 reasons:
#1) G when Tave <0 is not statistically different from 0 in the data set we have.
#2) Since only growing season data were used to compile the equation, there is 
#concern about extrapolating the equation to the much lower temperatures common
#to winter, and 3) We assume that months with average temperature <0 would often
#support an accumulated snowpack, and snow is a reasonable insualtor.  The 
#assumption that G is 0 when T <0 may not be completely valid, but we feel it is
#reasonable.
#In the original data from Bob, G is positive when heat flow is from the ground to the air and negative when heat flows from the air into the ground.Because of this, G must be multiplied by -1 before it can be used in the Priestly-Taylor function already in use (PET = (1/l)*1.126*sg*(Rn-G))
################################################################################

calcG <- function(Tave, nrow,ncol) { #everything that follows if function

#Pre-allocate the G matrix
G <- matrix(NA,nrow,ncol)

#Calculate G
G <- -0.0061*(Tave^2) - 0.0505*Tave - 0.2088

#If Tave <0, set G to 0
G[Tave <0] <-0

#Multiply by -1 to get G into the ground
G <- -1*G


#Output G
return(G)
} #close the function