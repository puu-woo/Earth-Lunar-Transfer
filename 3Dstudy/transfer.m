function [Trans_orb,Lunar_orb_trans,IConditions] = transfer(IConditions,lunar_posInit)


IConditions     =   EparkOrb ( IConditions );
r0 = IConditions.Earth.r0;
v0 = IConditions.Earth.v_init;
[~,~, min_distance1 ] = orbitRK89([r0;v0],IConditions,lunar_posInit);

v_first = IConditions.Earth.vInitpq(2);


IConditions.Earth.vInitpq = IConditions.Earth.vInitpq + [0,0.0001,0]';
IConditions     =   EparkOrb ( IConditions );
r0 = IConditions.Earth.r0;
v0 = IConditions.Earth.v_init;
[Trans_orb,Lunar_orb_trans, min_distance2 ] = orbitRK89([r0;v0],IConditions,lunar_posInit);


v_second = IConditions.Earth.vInitpq(2);
tor = 0.01;

while abs(min_distance2) > tor
    gradiant = (min_distance2 - min_distance1) / (v_second-v_first);
    IConditions.Earth.vInitpq = IConditions.Earth.vInitpq - [0, min_distance2 / gradiant, 0]';
    IConditions     =   EparkOrb ( IConditions );
    r0 = IConditions.Earth.r0;
    v0 = IConditions.Earth.v_init;
    min_distance1 = min_distance2;
    [Trans_orb,Lunar_orb_trans, min_distance2 ] = orbitRK89([r0;v0],IConditions,lunar_posInit);

    v_first = v_second;
    v_second = IConditions.Earth.vInitpq(2);
end





Trans_orb.oev   = rv2orb(IConditions.Earth.mu , IConditions.Earth.r0 , IConditions.Earth.v0);