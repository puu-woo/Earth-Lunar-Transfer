clear
format long

% Constants
R_earth         =   6378;
R_lunar         =   1743;
mu_earth        =   398600;
mu_lunar        =   4911.3;
lunar_wn        =   2*pi / (27*24*3600);
dt              =   5;


% Lunar
lunar_distance  =   388000;
lunar_posATinj  =   [ lunar_distance , 0 , 0 ];


% Orbits
altitude        =   500;
lunar_SOI       =   66000;
Rmission        =   100;

% r0 rotation
theta           =   -10 * pi / 180;


% Earth Parking Orbit
[r0,v0]         = EparkOrb ( mu_earth , altitude + R_earth , theta );


% Earth-Lunar Transfer Orbit
v_init              =   [ 0 , -10.6 , 0 ];
[y_trans,T_trans]   =   TransOrb( r0 , v_init , lunar_posATinj , lunar_SOI , dt );


% Lunar Orbit Injection
theta       =   getAngleFromPoint( lunar_posATinj , y_trans ( 1:3 , end )' );
v           =   [0,1,0];
v_init2     =   [ v * cos( theta + 0.5*pi ) , v * sin(theta+0.5*pi) , 0 ];
[y_loi,T_inj,lunar_position,lunar_velocity] = LOIOrb(y_trans(1:3,end)',v,lunar_posATinj,dt);


% Orbit Summation
y           =   [y_trans , y_loi];
viewer;