################################################################################
#This function calculates Rs, net incoming shortwave radiation at the ground.  
#It is a function of Ra (total incoming solar radiation at the top of the 
#atmosphere), but it is adjusted for scattering and absorption in the atmosphere. 
#Scattering and absorption are incorporated as a function of Tmax and Tmin, 
#which are used as a proxy for (primarily) humidity and cloudiness.
#Temperatures should be in degC
#k is the Hargeaves coefficient, a constant set to 0.16 in the interior and 
#0.19 in regions deemed to have a marine influence (Allen et al. 1998) based on
#the Nowacki et al. (2001) ecoregions  It is defined in airmass_final.txt.  
#B. O'Brien determined the following ecoregions to have persistent marine 
#influence: Cook Inlet Basin (B5), Beaufort Coastal Plain (P9), Seward Peninsula
#(P4), Kotzebue Sound Lowlands (P5), Bering Sea Islands (P7), Nulator Hills 
#(P2), Bristol Bay Lowlands (P6), Yukon-Kuskokwin Delta (P8), Aklun Mts. (P10),
#Aleutian Islands (M1), Alaska Peninsual (M7), Boundary Ranges (M2), Kodiak 
#Island (M3), Chugach-St. Elias  Mts. (M6), Gulf of Alaska coast (M5), Alexander
#Archipelago (M4), 
#Note that the spatial distribution and extent of areas that experience 
#predominantly marine vs. interior airmasses may change seasonally and/or over 
#time; thus our use of static k values may be problematic.
################################################################################

calcRs <- function(k,Ra,tmax,tmin,nrow,ncol) { #what follows is part of the function

#Pre-allocate a matrix
Rs <- matrix(NA,nrow,ncol)

#Calculate Rs from k, Ra, Tmax, and Tmin
#This performs the calculations only on grid cells that have a value
Rs[!is.na(tmax)] <- k[!is.na(tmax)]*Ra[!is.na(tmax)]*sqrt(tmax[!is.na(tmax)]-tmin[!is.na(tmax)])
return(Rs)
} #closes the function