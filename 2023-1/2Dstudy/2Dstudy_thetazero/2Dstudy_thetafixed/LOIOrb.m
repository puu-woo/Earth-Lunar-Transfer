function [LOI_orb,Lunar_orb,min_distance] = LOIOrb(v0,orb0,IConditions)


[LOI_orb,Lunar_orb,min_distance] = LorbitRK4(v0,orb0,IConditions,IConditions.Lunar.posATinj,"draft");