clear

format long
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
% theta_init           =   -0.233909026352280;

% Condition Struct
Earth_conditions = struct("mu",   mu_earth, ...
                          "h0",   altitude+R_earth, ...
                          "raan",raan, ...
                          "inc",inc, ...
                          "w", w);


Lunar_conditions = struct("mu",       mu_lunar, ...
                          "posATinj", lunar_posATinj, ...
                          "SOI",      lunar_SOI, ...
                          "h_mission",R_lunar+Rmission, ...
                          "w",        [0,0,2*pi / (27*24*3600)]);



IConditions       = struct("Earth",Earth_conditions, ...
                           "Lunar",Lunar_conditions, ...
                           "dt_rk89",   60, ...
                           "dt2_rk89", 5);


% Earth Parking Orbit
v_init_pq       =   [0 , 10.670566626 , 0 ]';
IConditions     =   EparkOrb ( IConditions, v_init_pq );


% solve Transfer & LOI orbit
lunar_posInit                   =   [388000*cos(-pi/2.6-raan) , 388000*sin(-pi/2.6-raan) , 0 ]';
[trans_orb,Lunar_orb_trans]     =   transfer( IConditions , lunar_posInit );


% Mission Orb maneuver
[mission_orb,Lunar_orb_mission] = maneuver(trans_orb.orb(:,end),Lunar_orb_trans.orb(:,end),IConditions);



orb.orb = [trans_orb.orb,mission_orb.orb];
Lunar_orb.orb = [Lunar_orb_trans.orb,Lunar_orb_mission.orb];
viewer;