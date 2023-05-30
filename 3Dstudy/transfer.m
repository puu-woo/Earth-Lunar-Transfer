function [Trans_orb,Lunar_orb_trans] = transfer(IConditions,lunar_posInit)

r0 = IConditions.Earth.r0;
v0 = IConditions.Earth.v_init;

[Trans_orb,Lunar_orb_trans, min_distance] = orbitRK89([r0;v0],IConditions,lunar_posInit,"transfer");

min_distance

end