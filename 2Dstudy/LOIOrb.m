function [LOI_orb,Lunar_orb,min_distance] = LOIOrb(orb0,IConditions)


[LOI_orb,Lunar_orb,min_distance] = LorbitRK4(orb0,IConditions,IConditions.Lunar.posATinj,"LOI");