function [mission_orb,Lunar_orb_mission] = maneuver(sat_PosVel,lunar_PosVel,IConditions);


rvn = sat_PosVel(4:6) - lunar_PosVel(4:6,end);
vel_init = rvn/norm(rvn)*sqrt(IConditions.Lunar.mu/(IConditions.Lunar.h_mission));
vel_init = vel_init + lunar_PosVel(4:6,end);

[mission_orb,Lunar_orb_mission, min_distance] = orbitRK89([sat_PosVel(1:3); vel_init],IConditions,lunar_PosVel(1:3,end),"draft");


end

