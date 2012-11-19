################################################################################
#This function calculates Priestley-Taylor PET from the alpha coefficient, SG 
#(s/s + gamma), Rn (net radiation), and G (the ground heat flux).
#SG, Rn and G are calculated in other R scripts.  
#alpha is set to 1.26.
#When alpha is set to 1.26, this function is calculating PET above a body of water;
#this implies true *potential* ET, and this value is probably most representative
#of atmospheric demand.  If alpha is varied by cover type, it can more closely
#approximate actual ET (excepting the fact that the P-T equation has no mechanism
#for limiting ET as a function of soil moisture). If the alpha coefficient used
#is calculated by comparing AET to PET under fully irrigated conditions, the
#result can be termed reference ET, and alpha should be constant for a given cover
#type.  The references for alpha that B. O'Brien used to produce the alpha map
#in reveg_pet_alpha_final.txt primarily calculate alpha as AET/PET under field
#conditions.  As a result these alpha values cannot be used to calculate PET or
#reference ET but are an attempt to estimate AET.  This is problematic, since
#alpha calculated in this way should vary seasonally, as well as interannually
#and with climatic conditions (see Engstrom et al. 2002).
#As a result, we preferntially use alpha = 1.26 to focus this study on variability
#and change atmospheric moisture demand.
#NB: Because of how the Priestley-Taylor equation has been set up, PET is 
#negative if Rn is negative.  Negative Rn is not unrealistic during 
#high-latitude winter, but negative PET is, so negative values of PET are set to 0.
#Source: Priestley and Taylor (1972) 
################################################################################

calcPET = function(SG,Rn,G,nrow,ncol)   {   #everything after this is function

#Pre-allocate the PET matrix
PET <- matrix(NA,nrow,ncol)

#Calculate PET
PET[!is.na(G)] <- 1.26*0.408*SG[!is.na(G)]*(Rn[!is.na(G)]-G[!is.na(G)])
#Multiply PET by 0.408 to convert from MJ m-2 day-1 to mm day-1 (equivalent to dividing by the latent heat of evaporation at 20C)

#If PET is less than 0, set to 0
PET[PET <0] <- 0
return(PET)
}#close the function