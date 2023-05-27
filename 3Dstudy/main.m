clear

format long
addpath("utillity/")
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

% r0 rotation
theta_init           =   -13.4 * pi / 180;
% theta_init           =   -0.233909026352280;

% Condition Struct
Earth_conditions = struct("mu",   mu_earth, ...
                          "h0",   altitude+R_earth, ...
                          "theta",theta_init);


Lunar_conditions = struct("mu",       mu_lunar, ...
                          "posATinj", lunar_posATinj, ...
                          "SOI",      lunar_SOI, ...
                          "h_mission",R_lunar+Rmission, ...
                          "w",        [0,0,2*pi / (27*24*3600)]);


IConditions       = struct("Earth",Earth_conditions, ...
                           "Lunar",Lunar_conditions, ...
                           "dt_rk4",   10, ...
                           "dt2", 5,...
                           "dt_rk89", 60);

% Earth Parking Orbit
[E_orb.r0, E_orb.v0]  = EparkOrb ( IConditions.Earth );

vn_init = -10.68262;
v_init = [ vn_init*sin(IConditions.Earth.theta) , vn_init*cos(IConditions.Earth.theta) , 0 ];


% solve Transfer & LOI orbit
lunar_posInit = [388000*cos(-pi/4-theta_init),388000*sin(-pi/4-theta_init),0];
[Trans_orb,Lunar_orb, min_distance] = EorbitRK89([E_orb.r0, v_init],IConditions,lunar_posInit');


viewer;