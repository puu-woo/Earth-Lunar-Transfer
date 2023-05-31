clear

format long
addpath("utillity\")
% Constants

R_earth         =   6378;
R_lunar         =   1743;
mu_earth        =   398600;
mu_lunar        =   4911.3;


% Orbits
altitude        =   500;
lunar_SOI       =   66000;
Rmission        =   100;


% Initial Plane
raan                 =   pi/2.56;
inc                  =   70 * pi / 180;
w                    =   180 * pi / 180;


% Condition Struct
Earth_conditions = struct("mu",   mu_earth, ...
                          "h0",   altitude+R_earth, ...
                          "raan", raan, ...
                          "inc",  inc, ...
                          "w",    w, ...
                          "vInitpq",[0 , 10.671211547851572 , 0 ]');


Lunar_conditions = struct("mu",       mu_lunar, ...
                          "R",        R_lunar, ...
                          "SOI",      lunar_SOI, ...
                          "h_mission",R_lunar+Rmission, ...
                          "w",        [0,0,2*pi / (27*24*3600)]);



IConditions       = struct("Earth",Earth_conditions, ...
                           "Lunar",Lunar_conditions, ...
                           "dt_rk89",   60, ...
                           "dt_rk4",5);


% solve Transfer & LOI orbit
lunar_posInit                                =   [ 388000 , 0 , 0 ]';
[trans_orb , Lunar_orb_trans , IConditions]  =   transfer( IConditions , lunar_posInit );


% Mission Orb maneuver
[mission_orb , Lunar_orb_mission]            =   maneuver(trans_orb.orb(:,end) , Lunar_orb_trans.orb(:,end) , IConditions);



% Results
results.IConditions = IConditions;

results.transferOrb   = trans_orb.orb;
results.missionOrb    = mission_orb.orb;
results.TOF           = [trans_orb.T,   mission_orb.T];
results.totalOrb      = [trans_orb.orb, mission_orb.orb];

results.transferOev   = trans_orb.oev;
results.missionOev    = mission_orb.oev;

results.earth_gravity = mission_orb.earth_gravity;
results.lunar_gravity = mission_orb.lunar_gravity;

results.dv_vector1    = IConditions.Earth.v_init - IConditions.Earth.v0;
results.dv_vector2    = mission_orb.orb(4:6,1) - trans_orb.orb(4:6,end);
results.dv_norms      = [norm(results.dv_vector1) , norm(results.dv_vector2)];

results.lunarOrb_atTrans   = Lunar_orb_trans.orb;
results.lunarOrb_atMission = Lunar_orb_mission.orb;
results.totalLunarOrb      = [Lunar_orb_trans.orb , Lunar_orb_mission.orb];


viewer(results,0);