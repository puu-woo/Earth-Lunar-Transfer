clear
<<<<<<< HEAD
=======
format long

>>>>>>> main
% Constants
R_earth         =   6378;
R_lunar         =   1743;
mu_earth        =   398600;
mu_lunar        =   4911.3;
<<<<<<< HEAD
lunar_w         =   [0,0,2*pi / (27*24*3600)];

% Orbits
altitude        = 500;
lunar_SOI       = 66000;
Rmission        = 100;
lunar_distance  = 388000;

% Phase 0
v0 = [ 0 , -sqrt(mu_earth / (R_earth + altitude)) , 0];

% Phase 1
r0_trans    =   [ - R_earth - altitude , 0 , 0];
a_trans     =   0.5 * ( norm ( r0_trans ) + ( lunar_distance - lunar_SOI ) );
v0_trans    =   [ 0 , -sqrt( mu_earth * ( 2 / norm(r0_trans) - 1 / a_trans ) ) , 0 ];
T_trans     =   pi * sqrt( a_trans ^3 / mu_earth );


% Phase 2
a_inj       =   0.5 * ( lunar_SOI + Rmission );
T_inj        =   0.60432*pi * sqrt( a_inj ^3 / mu_lunar );


K1 = fix(T_trans/5);
K2 = fix(T_inj/5);
K = K1+K2;
lunar_pos(K1,:) = [lunar_distance,0,0];
lunar_vel(K1,:) = cross(lunar_w,lunar_pos(K1,:));
for i = 0:K1-2
    j = K1-i;
    lunar_pos(j-1,:) = lunar_pos(j,:)-lunar_vel(j,:)*5;
    lunar_vel(j-1,:) = cross(lunar_w,lunar_pos(j,:));
end

for i = K1+1:K
    lunar_pos(i,:) = lunar_pos(i-1,:)+lunar_vel(i-1,:)*5;
    lunar_vel(i,:) = cross(lunar_w,lunar_pos(i-1,:));
end



v2          =   [ 0 , sqrt( mu_earth * ( 2 / (lunar_distance - lunar_SOI ) - 1 / a_trans ) ) , 0];
% v2n         =   [ 0 , -sqrt( mu_lunar * ( 2 / lunar_SOI - 1 / a_inj ) ) , 0]+lunar_vel(K1,:);
% dv1         =   v2n - v2;
dv1 = [0,0.75,0];
orb_trans   =   EorbitRK4 ( K1 , 5 , [ r0_trans , v0_trans ] );
orb_inj = MorbitRK4(K2,5,[lunar_distance-lunar_SOI;0;0;(v2+dv1)'],lunar_pos(K1:end,:)');
orb = [orb_trans,orb_inj];
delv = [v0_trans-v0 ; dv1];

% % Phase 3
% rm0 = orb_inj(1:3,end)-lunar_pos(end,:)';
% angle = atan2(rm0(2), rm0(1));
% 
% TOF2 = 150000;
% for i = K2+1:K2+TOF2/5
%     lunar_pos(i,:) = lunar_pos(i-1,:)+lunar_vel(i-1,:)*5;
%     lunar_vel(i,:) = -cross(lunar_pos(i-1,:),lunar_w);
% end
% 
% v0n = sqrt(mu_lunar/norm(rm0));
% v0nx = -v0n*sin(angle)+lunar_vel(K2,1);
% v0ny = v0n*cos(angle)+lunar_vel(K2,2);

% orb_mission = MorbitRK4(TOF2,5,[orb_inj(1:3,end);v0nx;v0ny;0],lunar_pos(K2:end,:)');



% Earth
theta = linspace(0,2*pi,1000);
E_x = R_earth*cos(theta);
E_y = R_earth*sin(theta);
L_x = R_lunar*cos(theta)+lunar_distance;
L_y = R_lunar*sin(theta);
L_SOI_x = lunar_SOI*cos(theta)+lunar_distance;
L_SOI_y = lunar_SOI*sin(theta);
=======
lunar_wn        =   2*pi / (27*24*3600);
dt              =   5;


% Lunar
lunar_distance  =   388000;
lunar_posATinj  =   [ lunar_distance , 0 , 0 ];


% Orbits
altitude        =   500;
lunar_SOI       =   66000;
Rmission        =   100;


% Earth Parking Orbit
[r0,v0]         = EparkOrb ( mu_earth , altitude + R_earth );


% Earth-Lunar Transfer Orbit
v_init              =   [ 0 , -10.7 , 0 ];
[y_trans,T_trans]   =   TransOrb( r0 , v_init , lunar_posATinj , lunar_SOI , dt );


% Lunar Orbit Injection
theta       =   getAngleFromPoint( lunar_posATinj , y_trans ( 1:3 , end )' );
v           =   0;
v_init2     =   [ v * cos( theta + 0.5*pi ) , v * sin(theta+0.5*pi) , 0 ];
[y_loi,T_inj,lunar_position,lunar_velocity] = LOIOrb(y_trans(1:3,end)',v_init2,lunar_posATinj,dt);


% Orbit Summation
y           =   [y_trans , y_loi];
viewer;
>>>>>>> main
