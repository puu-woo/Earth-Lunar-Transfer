clear
format long
% Constants
R_earth         =   6378;
R_lunar         =   1743;
mu_earth        =   398600;
mu_lunar        =   4911.3;
lunar_w         =   [0,0,2*pi / (27*24*3600)];
dt              =   5;
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
T_ref        =   0.7*pi * sqrt( a_inj ^3 / mu_lunar );

K1 = fix(T_trans/dt);
K2 = fix(T_ref/dt);
K = K1+K2;
lunar_pos(K1,:) = [lunar_distance,0,0];
lunar_vel(K1,:) = cross(lunar_w,lunar_pos(K1,:));
for i = 0:K1-2
    j = K1-i;
    lunar_pos(j-1,:) = lunar_pos(j,:)-lunar_vel(j,:)*dt;
    lunar_vel(j-1,:) = cross(lunar_w,lunar_pos(j,:));
end

for i = K1+1:K
    lunar_pos(i,:) = lunar_pos(i-1,:)+lunar_vel(i-1,:)*dt;
    lunar_vel(i,:) = cross(lunar_w,lunar_pos(i-1,:));
end

v2          =   [ 0 , sqrt( mu_earth * ( 2 / (lunar_distance - lunar_SOI ) - 1 / a_trans ) ) , 0];
orb_trans   =   EorbitRK4 ( K1 , dt , [ r0_trans , v0_trans ] );

dv1 = [0,0.730140014317,0];
addv = [0,0.01,0];
tor = 10^-9;

while true
    orb_inj = MorbitRK4(K2,dt,[lunar_distance-lunar_SOI;0;0;(v2+dv1)'],lunar_pos(K1:end,:)');
    
    r_mci = orb_inj(1:3,:)-lunar_pos(K1:end,:)';
    for i = 1:K2
        d_mci(i) = norm(r_mci(:,i));
    end

    [d_min,index] = min(d_mci);
    tar = d_min-R_lunar-100;
    if tar > tor
        disp(d_min);
        dv1 = dv1 + addv;
    elseif tar < -tor
        dv1 = dv1 - addv;
        addv = addv/10;
    else
        break
    end
end

T_inj_real = (index-1)*dt;


% Phase 3

r_arr = r_mci(:,index);
v_arr = orb_inj(4:6,index)-lunar_vel(K1+(index-1),:)';

v_need = sqrt(mu_lunar/(R_lunar+Rmission));
angle = atan2(r_arr(2),r_arr(1));

vx_need = -v_need*sin(angle)+lunar_vel(K1+index-1,1);
vy_need = v_need*cos(angle)+lunar_vel(K1+index-1,2);

dv2 = [vx_need-v_arr(1),vy_need-v_arr(2),0];
orb_mission = MorbitRK4(K2-index+1,dt,[orb_inj(1:3,index);1.01*vx_need;1.01*vy_need;0]',lunar_pos(K1+index-1:end,:)');

orb = [orb_trans,orb_inj(:,2:index-1),orb_mission];
delv = [v0_trans-v0 ; dv1 ; dv2];


viewer;