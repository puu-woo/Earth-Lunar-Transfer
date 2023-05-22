clear

format long
% Constants

R_earth         =   6378;
R_lunar         =   1743;
mu_earth        =   398600;
mu_lunar        =   4911.3;
lunar_wn        =   2*pi / (27*24*3600);
dt              =   10;

% Lunar
lunar_distance  =   388000;
lunar_posATinj  =   [ lunar_distance , 0 , 0 ];


% Orbits
altitude        =   500;
lunar_SOI       =   66000;
Rmission        =   100;

% r0 rotation
theta_init           =   13 * pi / 180;

[r0 , v0,...
 y_trans , y_loi ,...
 T_trans , T_loi ,...
 lunar_position_inj , lunar_velocity_inj] = Earth2MissionOrb(mu_earth, altitude + R_earth , theta_init,lunar_posATinj, lunar_SOI, Rmission+R_lunar, dt);



% Orbit Summation
y           =   [y_trans , y_loi];

viewer;
