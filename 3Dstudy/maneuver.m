function [mission_orb,Lunar_orb_mission] = maneuver(sat_PosVel,lunar_PosVel,IConditions)

re = sat_PosVel(1:3);
ve = sat_PosVel(4:6);
rl = lunar_PosVel(1:3);
vl = lunar_PosVel(4:6);

vn = sqrt(IConditions.Lunar.mu / norm( re - rl ));



rel_v = (ve-vl) / norm (ve-vl) * vn;
oev = rv2orb(IConditions.Lunar.mu , re-rl , rel_v);

if oev(3) > 0.5*pi
    vn = - vn;
    rel_v =  (ve-vl) / norm (ve-vl) * vn;
    oev = rv2orb(IConditions.Lunar.mu , re-rl , rel_v);
end

DCM  = DCMeci2pq(oev(4)+oev(6),oev(3),oev(5));
v_pq = [0, sqrt(IConditions.Lunar.mu / norm( re - rl )) , 0]';
v0   = DCM'*v_pq;




% [mission_orb,Lunar_orb_mission, ~] = orbitRK89([sat_PosVel(1:3); vel_init],IConditions,lunar_PosVel(1:3,end),"draft");
[mission_orb,Lunar_orb_mission] = orbitRK4([re-rl; v0],IConditions,-lunar_PosVel(1:3));
mission_orb.oev = rv2orb(IConditions.Lunar.mu , re-rl , v0);

end

