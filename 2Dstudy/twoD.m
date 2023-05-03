clear
% Constants
R_earth         =   6378;
R_lunar         =   1743;
mu_earth        =   398600;
mu_lunar        =   4911.3;


% Orbits
altitude        = 500;
lunar_SOI       = 66000;
Rmission        = 100;
lunar_distance  = 388000;
lunar_w = [0,0,2*pi / (27*24*3600)];


% Phase 1
r0          =   [ - R_earth - altitude , 0 , 0];
a_trans     =   0.5 * ( norm ( r0 ) + ( lunar_distance - lunar_SOI ) );
v0          =   [ 0 , -sqrt( mu_earth * ( 2 / norm(r0) - 1 / a_trans ) ) , 0 ];
T_trans     =   pi * sqrt( a_trans ^3 / mu_earth );
y           =   EorbitRK4 ( T_trans , 5 , [ r0 , v0 ] );


% Phase 2
lunar_pos(1,:) = [lunar_distance,0,0];
lunar_vel(1,:) = [0, sqrt(mu_earth / norm ( lunar_pos(1,:) )) ,0];

a_inj       =   0.5 * ( lunar_SOI + Rmission );
v2          =   [ 0 , -sqrt( mu_earth * ( 2 / (lunar_distance - lunar_SOI ) - 1 / a_trans ) ) , 0];
v2n         =   [ 0 , -sqrt( mu_lunar * ( 2 / lunar_SOI - 1 / a_inj ) ) , 0]+lunar_vel(1,:);
dv1         =   v2n - v2;
T_in        =   0.60432*pi * sqrt( a_inj ^3 / mu_lunar );


TOF = T_in;
for i = 2:TOF/5+1
    lunar_pos(i,:) = lunar_pos(i-1,:)+lunar_vel(i-1,:)*5;
    lunar_vel(i,:) = -cross(lunar_pos(i-1,:),lunar_w);
end

y2 = MorbitRK4(T_in,5,[lunar_distance-lunar_SOI;0;0;v2n'],lunar_pos(:,:)');

% Phase 3
rm0 = y2(1:3,end)-lunar_pos(end,:)';
angle = atan2(rm0(2), rm0(1));

TOF2 = 150000;
lunar_pos2(1,:) = lunar_pos(end,:);
lunar_vel2(1,:) = lunar_vel(end,:);
for i = 2:TOF2/5+1
    lunar_pos2(i,:) = lunar_pos2(i-1,:)+lunar_vel2(i-1,:)*5;
    lunar_vel2(i,:) = -cross(lunar_pos2(i-1,:),lunar_w);
end

v0n = sqrt(mu_lunar/norm(rm0));
v0nx = -v0n*sin(angle)+lunar_vel2(1,1);
v0ny = v0n*cos(angle)+lunar_vel2(1,2);

y3 = MorbitRK4(TOF2,5,[y2(1:3,end);v0nx;v0ny;0],lunar_pos2(:,:)');

% Earth
theta = linspace(0,2*pi,1000);
E_x = R_earth*cos(theta);
E_y = R_earth*sin(theta);
L_x = R_lunar*cos(theta)+lunar_distance;
L_y = R_lunar*sin(theta);
L_SOI_x = lunar_SOI*cos(theta)+lunar_distance;
L_SOI_y = lunar_SOI*sin(theta);