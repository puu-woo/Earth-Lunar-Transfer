function [M_orb, Lunar_orb_ex] = Mission_Orb(orb0,lunar_orb,IConditions)

ang = getAngleFromPoint(lunar_orb.pos(:,end),orb0(1:3));

distance = IConditions.Lunar.h_mission;
vn = sqrt( IConditions.Lunar.mu / distance );
v0(1,1) = vn*cos(ang+0.5*pi)+lunar_orb.vel(1,end);
v0(2,1) = vn*sin(ang+0.5*pi)+lunar_orb.vel(2,end);
v0(3,1) = +lunar_orb.vel(3,end);


[M_orb, Lunar_orb_ex] = LorbitRK4([orb0(1:3);v0],IConditions,lunar_orb.pos(:,end),"draft");