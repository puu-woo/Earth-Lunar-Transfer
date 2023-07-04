function viewer2(results)

% Variables
IConditions = results.IConditions;

dt_transer = results.IConditions.dt_rk89;
dt_mission = results.IConditions.dt_rk4;

transfer_orb = results.transferOrb;
mission_orb = results.missionOrb;
total_orb = results.totalOrb;

lunarOrb_atTrans = results.lunarOrb_atTrans;
lunarOrb_atManeuver = results.lunarOrb_atMission;
lunarOrb = results.totalLunarOrb;

TOF_transfer = results.TOF(1);
TOF_maneuver = results.TOF(2);

total_LunarOrb = results.totalLunarOrb;
relative_pos = total_orb(1:3,:) - total_LunarOrb(1:3,:);

% Mission Orbit boundary
theta = linspace(0,2*pi,100);
H = IConditions.Lunar.h_mission;
H_x = H*cos(theta);
H_y = H*sin(theta);

% Lunar
R_lunar = IConditions.Lunar.R;
[X,Y,Z] = sphere();
X = R_lunar*X;
Y = R_lunar*Y;
Z = R_lunar*Z;

fg = figure(1);
fg.Position = [400,150,1280,720];


tspace1 = 0:dt_transer:TOF_transfer;
tspace2 = TOF_transfer:dt_mission:TOF_transfer+TOF_maneuver;

Rel_pos1 = transfer_orb(1:3,:)-lunarOrb_atTrans(1:3,:);
Rel_pos2 = mission_orb(1:3,:)-lunarOrb_atManeuver(1:3,:);

% plot(tspace1/86400,vecnorm(Rel_pos1),'Color','b','DisplayName','distance from moon center');
% hold on
plot((tspace2-tspace2(1))/86400,vecnorm(Rel_pos2),'Color','b','HandleVisibility','off');
% hold off
title("Distance From Moon")
grid on
ylim([1842.9,1843.08])
xlabel("day");
ylabel("km");
legend();
