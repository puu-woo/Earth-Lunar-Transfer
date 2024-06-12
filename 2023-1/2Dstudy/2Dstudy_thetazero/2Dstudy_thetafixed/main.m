clear

format long
addpath("utillity/")
% Constants

R_earth         =   6378;
R_lunar         =   1743;
mu_earth        =   398600;
mu_lunar        =   4911.3;
dt              =   10;

% Lunar
lunar_distance  =   388000;
lunar_posATinj  =   [ lunar_distance , 0 , 0 ];


% Orbits
altitude        =   500;
lunar_SOI       =   66000;
Rmission        =   100;

% r0 rotation
theta_init           =   0;


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
                           "dt",   dt);


% solve Transfer & LOI orbit
[E_orb, Trans_orb ,LOI_orb, Lunar_orb] = Earth_LOI_Orb(IConditions);

% Mission Orbit
[M_orb, Lunar_orb.ex] = Mission_Orb(LOI_orb.orb(:,end),Lunar_orb.inj,IConditions);


% Orbit Summation
result.orb           =   [Trans_orb.orb , LOI_orb.orb];
viewer;
