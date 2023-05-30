function [mission_orb,Lunar_orb_mission] = maneuver(sat_PosVel,lunar_PosVel,IConditions)


rvn = sat_PosVel(4:6) - lunar_PosVel(4:6);
vel_init = rvn/norm(rvn)*sqrt(IConditions.Lunar.mu/norm(sat_PosVel(1:3) - lunar_PosVel(1:3)));
vel_init = vel_init + lunar_PosVel(4:6);


% [mission_orb,Lunar_orb_mission, ~] = orbitRK89([sat_PosVel(1:3); vel_init],IConditions,lunar_PosVel(1:3,end),"draft");
[mission_orb,Lunar_orb_mission] = orbitRK4([sat_PosVel(1:3); vel_init],IConditions,lunar_PosVel(1:3));


end

