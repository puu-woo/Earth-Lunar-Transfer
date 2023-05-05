clear
format long
% Constants
R_earth         =   6378;
R_lunar         =   1743;
mu_earth        =   398600;
mu_lunar        =   4911.3;
lunar_wn        =   2*pi / (27*24*3600);
lunar_w         =   [0,0,2*pi / (27*24*3600)];
dt              =   5;
simTime         =   24*3600*8;


% Orbits
altitude        =   500;
lunar_SOI       =   66000;
Rmission        =   100;
lunar_distance  =   388000;
lunar_posATinj  =   [ lunar_distance , 0 , 0 ];


% Phase 1
r0_trans        =   [ - R_earth - altitude , 0 , 0];
a_trans         =   0.5 * ( norm ( r0_trans ) + ( lunar_distance - lunar_SOI ) );
v0_trans        =   [ 0 , -sqrt( mu_earth * ( 2 / norm(r0_trans) - 1 / a_trans ) ) , 0 ];
T_trans         =   pi * sqrt( a_trans ^3 / mu_earth );

% Phase 2
r0_inj          =   [lunar_distance - lunar_SOI ,0,0];
v0_inj          =   [ 0 , sqrt( mu_earth * ( 2 / (lunar_distance - lunar_SOI ) - 1 / a_trans ) ) , 0];
dv1             =   [0,0.730140014317,0];
a_inj           =   0.5 * ( lunar_SOI + Rmission );

% T_inj         =   2*pi * sqrt( a_inj ^3 / mu_lunar );
T_inj           =   167185;


% Phase 3
v_need          = sqrt ( mu_lunar / ( R_lunar + Rmission ) );

% Simulink output
out             = sim ( 'PatchedConic.slx' );
orb_eci         = out.orb_eci.Data;
orb_mci         = out.orb_mci.Data;
timespace       = out.orb_eci.Time;
lpos            = out.lunar_pos.Data;


viewer;
