clear

format long
addpath("utillity\")
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
raan                 =   0 * pi / 180;
inc                  =   45 * pi / 180;
w                    =   180 * pi / 180;


% Condition Struct
Earth_conditions = struct("mu",   mu_earth, ...
                          "h0",   altitude+R_earth, ...
                          "raan",raan, ...
                          "inc",inc, ...
                          "w", w);


Lunar_conditions = struct("mu",       mu_lunar, ...
                          "R",        R_lunar, ...
                          "posATinj", lunar_posATinj, ...
                          "SOI",      lunar_SOI, ...
                          "h_mission",R_lunar+Rmission, ...
                          "w",        [0,0,2*pi / (27*24*3600)]);



IConditions       = struct("Earth",Earth_conditions, ...
                           "Lunar",Lunar_conditions, ...
                           "dt_rk89",   10, ...
                           "dt2_rk89", 1, ...
                           "dt_rk4",1);


% Earth Parking Orbit
v_init_pq       =   [0 , 10.6705591078 , 0 ]';
IConditions     =   EparkOrb ( IConditions, v_init_pq );



% solve Transfer & LOI orbit
lunar_posInit                   =   [388000*cos(-pi/2.6-raan) , 388000*sin(-pi/2.6-raan) , 0 ]';
[trans_orb,Lunar_orb_trans]     =   transfer( IConditions , lunar_posInit );


% Mission Orb maneuver
[mission_orb,Lunar_orb_mission] = maneuver(trans_orb.orb(:,end),Lunar_orb_trans.orb(:,end),IConditions);


% Get Orbit Elements
trans_orb.oev = rv2orb(IConditions.Earth.mu,IConditions.Earth.r0,IConditions.Earth.v0);
mission_orb.oev = rv2orb(IConditions.Lunar.mu,mission_orb.orb(1:3,1)-Lunar_orb_mission.orb(1:3,1),mission_orb.orb(4:6,1)-Lunar_orb_mission.orb(4:6,1));


% Results
results.IConditions = IConditions;

results.transferOrb = trans_orb.orb;
results.missionOrb = mission_orb.orb;
results.TOF = [trans_orb.T, mission_orb.T];
results.totalOrb = [trans_orb.orb, mission_orb.orb];

results.earth_gravity = mission_orb.earth_gravity;
results.lunar_gravity = mission_orb.lunar_gravity;

results.dv_vector1 = IConditions.Earth.v_init-IConditions.Earth.v0;
results.dv_vector2 = mission_orb.orb(4:6,1)-trans_orb.orb(4:6,end);
results.dv_norms = [norm(results.dv_vector1), norm(results.dv_vector2)];

results.lunarOrb_atTrans = Lunar_orb_trans.orb;
results.lunarOrb_atmission = Lunar_orb_mission.orb;
results.totalLunarOrb = [Lunar_orb_trans.orb, Lunar_orb_mission.orb];


viewer(results,0);