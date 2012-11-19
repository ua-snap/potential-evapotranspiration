################################################################################
#This calculates net radiation available for driving PET as a function of 
#incoming shortwave radiation, albedo, and net longwave radiation in the out-
#going direction.
#Since Rl is calculated as net outgoing, it is subtracted from (1-a)Rs not added.
#Spatially explicit albedo values were derived from Eugster et al. (2000) by B. 
#O'Brien and are described in reveg_pet_albedo_final.txt.  Please see commentary
#about the albedo values below.
################################################################################
calcRn <- function(albedo,Rs,Rl,nrow,ncol) {  #everything that follows is function

#Pre-allocate the Rn matrix
Rn <- matrix(NA,nrow,ncol)

#Calculate Rn
Rn[!is.na(Rs)] <- ((1-albedo[!is.na(Rs)])*Rs[!is.na(Rs)])-Rl[!is.na(Rs)]
return(Rn)
} #close the function

################################################################################
#Albedo values in reveg_pet_albedo.txt are as follows:
#Perennial snow/ice     0.40
#Barren ground          0.20
#Upland tundra          0.16
#Wetland tundra         0.15
#Deciduous forest       0.16
#Coniferous forest      0.08
#Open water             0.06

#These values are temporally static and typically represent mid-summer minimum
#albedo on overcast days (Eugster et al. 2000).  Albedo would be higher during 
#months when there is snowcover and may also be slightly higher under clear or
#partly cloudy conditions than under the overcast conditions specified in 
#Eugster et al. (2000) (Betts and Ball, 1997; Duchon and Hamm, 2006).

#These two choices (static use of mid-summer albedo and the use of overcast-day
#minimum albedo) may explain why albedo values in reveg_pet_albedo_final.txt are
#at the low end of published albedo ranges. In addition, the albedo value for 
#water quoted here is more appropriate under conditions of high solar incidence 
#angle than the lower solar incidence angles experienced at high latitudes.

#Albedo values from Barry and Chorley (2003).  Atmosphere, Weather and Climate
#Fresh snow             0.8-0.9
#Melting snow           0.4-0.6
#Sand                   0.3-0.35
#Grass                  0.18-0.25
#Deciduous forest       0.15-0.18
#Coniferous forest      0.09-0.15
#Water                  0.06-0.1

#Albedo values compiled by Cole and Saleska (U. Arizona GEOS478. Fall 2010)
#Fresh snow             0.75-0.95
#Old snow               0.4-0.6
#Sand                   0.18-0.28
#Grass/open forest      0.15-0.25
#Dense forest           0.05-0.10
#Water                  0.02-0.06

#Albedo values for boreal forest sites from Betts and Ball (1997)
#                       Snow-free           Snowy
#Grass                  0.197               0.75
#Aspen - bare           0.12                0.21
#Aspen - leafed out     0.16                N/A
#Jack pine              0.09                0.15
#Spruce/poplar          0.08                0.11

#Albedo values from Chapin et al. (2005)
#                       Snow-free           Snowy
#Tundra                 0.17                0.8
#Shrub                  0.15                0.6
#Forest                 0.11                0.2