clear

format long
addpath("..","../utillity/")
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
theta_init           =   -13 * pi / 180;
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



% solve Transfer & LOI orbit
[E_orb.r0, E_orb.v0]  = EparkOrb ( IConditions.Earth );
vn_init                =   -10.6;
v_init = [ vn_init*sin(IConditions.Earth.theta) , vn_init*cos(IConditions.Earth.theta) , 0 ];
[Trans_orb,~] = EorbitRK4 ([ E_orb.r0 , v_init ] , IConditions );

vn_init2                =   -10.65;
v_init = [ vn_init2*sin(IConditions.Earth.theta) , vn_init2*cos(IConditions.Earth.theta) , 0 ];
[Trans_orb2,~] = EorbitRK4 ([ E_orb.r0 , v_init ] , IConditions );

vn_init3                =   -10.67;
v_init = [ vn_init3*sin(IConditions.Earth.theta) , vn_init3*cos(IConditions.Earth.theta) , 0 ];
[Trans_orb3,~] = EorbitRK4 ([ E_orb.r0 , v_init ] , IConditions );

vn_init4                =   -10.7;
v_init = [ vn_init4*sin(IConditions.Earth.theta) , vn_init4*cos(IConditions.Earth.theta) , 0 ];
[Trans_orb4,~] = EorbitRK4 ([ E_orb.r0 , v_init ] , IConditions );





% Figure
theta = linspace(0,2*pi,100);
figure(1)
p_trj = plot(Trans_orb.orb(1,:),Trans_orb.orb(2,:));
hold on
p_trj2 = plot(Trans_orb2.orb(1,:),Trans_orb2.orb(2,:));
p_trj3 = plot(Trans_orb3.orb(1,:),Trans_orb3.orb(2,:));
p_trj4 = plot(Trans_orb4.orb(1,:),Trans_orb4.orb(2,:));


p_soi = plot(lunar_SOI*cos(theta)+lunar_distance, lunar_SOI*sin(theta),'--','Color','k');
plot(0,0,'Marker','o','Color','b')
plot(388000,0,'Marker','o','Color',[0.8,0.8,0])
grid on
hold off
ylim([-3,3]*10^5);
xlim([-1,5]*10^5);

legend([p_trj,p_trj2,p_trj3,p_trj4,p_soi],['  v=',num2str(-vn_init),'0km/s'],...
                                          ['  v=',num2str(-vn_init2),'km/s'],...
                                          ['  v=',num2str(-vn_init3),'km/s'],...
                                          ['  v=',num2str(-vn_init4),'0km/s'],...
                                          'Lunar soi','Location','best')
title(['Earth Center','  (\theta=',num2str(theta_init*180/pi),'\circ)']);
xlabel("km");
ylabel("km");




lunar_w = IConditions.Lunar.w;
dt = IConditions.dt_rk4;
l = length(Trans_orb.orb);
lunar_pos_trans(:,l+1) = IConditions.Lunar.posATinj;
lunar_vel_trans(:,l+1) = cross(IConditions.Lunar.w,IConditions.Lunar.posATinj);

for i = 1:l
    lunar_pos_trans(:,l+1-i) = lunar_pos_trans(:,l+2-i) - lunar_vel_trans(:,l+2-i)*dt';
    lunar_vel_trans(:,l+1-i) = cross(lunar_w,lunar_pos_trans(:,l+2-i))';
end

relative_position = Trans_orb.orb(1:3,:)-lunar_pos_trans;

dn = vecnorm(relative_position);
ts = 0:dt:(length(result.orb)-1)*(dt);

figure(2)
plot()
