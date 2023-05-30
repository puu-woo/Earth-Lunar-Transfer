clear

format long
addpath("..\","..\utillity\")
% Constants

R_earth         =   6378;
R_lunar         =   1743;
mu_earth        =   398600;
mu_lunar        =   4911.3;

% Lunar
lunar_distance  =   388000;
lunar_posATinj  =   [ lunar_distance , 0 , 0 ];


% Orbits
altitude        =   500;
lunar_SOI       =   66000;
Rmission        =   100;


% Initial Plane
% raan                 =   0 * pi / 180;
raan                =   pi/2.52;
incs                 =   linspace(10,70,10) * pi / 180;
w                    =   180 * pi / 180;

for i = 1:length(incs)
inc = incs(i);
Earth_conditions = struct("mu",   mu_earth, ...
                          "h0",   altitude+R_earth, ...
                          "raan", raan, ...
                          "inc",  inc, ...
                          "w",    w, ...
                          "vInitpq",[0 , 10.665856199999997 , 0 ]');


Lunar_conditions = struct("mu",       mu_lunar, ...
                          "R",        R_lunar, ...
                          "posATinj", lunar_posATinj, ...
                          "SOI",      lunar_SOI, ...
                          "h_mission",R_lunar+Rmission, ...
                          "w",        [0,0,2*pi / (27*24*3600)]);



IConditions       = struct("Earth",Earth_conditions, ...
                           "Lunar",Lunar_conditions, ...
                           "dt_rk89",   60, ...
                           "dt2_rk89", 1, ...
                           "dt_rk4",1);


% solve Transfer & LOI orbit
lunar_posInit                   =   [388000,0,0]';
[trans_orb,Lunar_orb_trans,IConditions]     =   transfer( IConditions , lunar_posInit );


% Mission Orb maneuver
[mission_orb,Lunar_orb_mission] = maneuver(trans_orb.orb(:,end),Lunar_orb_trans.orb(:,end),IConditions);


% Get Orbit Elements
trans_orb.oev = rv2orb(IConditions.Earth.mu,IConditions.Earth.r0,IConditions.Earth.v0);
mission_orb.oev = rv2orb(IConditions.Lunar.mu,mission_orb.orb(1:3,1)-Lunar_orb_mission.orb(1:3,1),mission_orb.orb(4:6,1)-Lunar_orb_mission.orb(4:6,1));
mission_orb.oev
oev(i,:) = mission_orb.oev
end


% Analysis
a = oev(:,1);
ecc = oev(:,2);
inc = oev(:,3) * 180/pi;
w = oev(:,4) * 180/pi;
raan = oev(:,5) * 180/pi;
f = oev(:,6) * 180/pi;

theta = linspace(0,2*pi,100);

view(3)
hold on
for i = 1:length(a)
    r(1,:) = a(i)*cos(theta);
    r(2,:) = a(i)*sin(theta);
    r(3,:) = 0*sin(theta);

    DCM = DCMpq2inertial(oev(i,4),oev(i,3),oev(i,5));
    or = DCM'*r;
    plot3(or(1,:),or(2,:),or(3,:),"DisplayName",num2str(incs(i)*180/pi))

    grid on

    xlim([-2000,2000])
    ylim([-2000,2000])
    zlim([-2000,2000])
end
legend
hold off
