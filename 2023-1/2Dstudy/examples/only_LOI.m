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
theta_init           =   -13.402 * pi / 180;
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


theta1 = -10;
theta2 = -13.4;
theta3 = -15;
theta4 = -18;

% solve Transfer & LOI orbit
% Earth Parking Orbit
IConditions.Earth.theta = theta1 * pi / 180;
[E_orb.r0, E_orb.v0]  = EparkOrb ( IConditions.Earth );

% Earth-Lunar Transfer Orbit
v_init                =   -10;
[Trans_orb,Lunar_orb_trans]           =   TransOrb( E_orb.r0 , v_init , IConditions );

% LOI maneuver
[LOI_orb,Lunar_orb_inj,min_distance] = LorbitRK4(Trans_orb.orb(:,end)',IConditions,IConditions.Lunar.posATinj,"LOI");


orb = [Trans_orb.orb,LOI_orb.orb];
lunar_position = [Lunar_orb_trans.pos(:,1:end-1),Lunar_orb_inj.pos];
relative_position = orb(1:3,:)-lunar_position;


%%
% solve Transfer & LOI orbit
% Earth Parking Orbit
IConditions.Earth.theta = theta2 * pi / 180;
[E_orb.r0, E_orb.v0]  = EparkOrb ( IConditions.Earth );

% Earth-Lunar Transfer Orbit
v_init                =   -10;
[Trans_orb2,Lunar_orb_trans2]           =   TransOrb( E_orb.r0 , v_init , IConditions );

% LOI maneuver
[LOI_orb2,Lunar_orb_inj2,min_distance] = LorbitRK4(Trans_orb2.orb(:,end)',IConditions,IConditions.Lunar.posATinj,"LOI");


orb2 = [Trans_orb2.orb,LOI_orb2.orb];
lunar_position2 = [Lunar_orb_trans2.pos(:,1:end-1),Lunar_orb_inj2.pos];
relative_position2 = orb2(1:3,:)-lunar_position2;

%%
% solve Transfer & LOI orbit
% Earth Parking Orbit
IConditions.Earth.theta = theta3 * pi / 180;
[E_orb.r0, E_orb.v0]  = EparkOrb ( IConditions.Earth );

% Earth-Lunar Transfer Orbit
v_init                =   -10;
[Trans_orb3,Lunar_orb_trans3]           =   TransOrb( E_orb.r0 , v_init , IConditions );

% LOI maneuver
[LOI_orb3,Lunar_orb_inj3,min_distance] = LorbitRK4(Trans_orb3.orb(:,end)',IConditions,IConditions.Lunar.posATinj,"LOI");


orb3 = [Trans_orb3.orb,LOI_orb3.orb];
lunar_position3 = [Lunar_orb_trans3.pos(:,1:end-1),Lunar_orb_inj3.pos];
relative_position3 = orb3(1:3,:)-lunar_position3;

%%
% solve Transfer & LOI orbit
% Earth Parking Orbit
IConditions.Earth.theta = theta4 * pi / 180;
[E_orb.r0, E_orb.v0]  = EparkOrb ( IConditions.Earth );

% Earth-Lunar Transfer Orbit
v_init                =   -10;
[Trans_orb4,Lunar_orb_trans4]           =   TransOrb( E_orb.r0 , v_init , IConditions );

% LOI maneuver
[LOI_orb4,Lunar_orb_inj4,min_distance] = LorbitRK4(Trans_orb4.orb(:,end)',IConditions,IConditions.Lunar.posATinj,"LOI");


orb4 = [Trans_orb4.orb,LOI_orb4.orb];
lunar_position4 = [Lunar_orb_trans4.pos(:,1:end-1),Lunar_orb_inj4.pos];
relative_position4 = orb4(1:3,:)-lunar_position4;



% Figure
theta = linspace(0,2*pi,100);
fg = figure(1);
fg.Position = [600,100,600,800];
subplot(2,1,1)
p_trj = plot(orb2(1,:),orb2(2,:),'LineWidth',1.5,'Color','r');
hold on
plot(lunar_position2(1,:),lunar_position2(2,:),'Color',[0.8,0.8,0.2],'LineWidth',1.5)
p_soi = plot(lunar_SOI*cos(theta)+lunar_distance, lunar_SOI*sin(theta),'--','Color','k');
p_pl=plot(lunar_position2(1,end),lunar_position2(2,end),'Marker','o','Color',[0.8,0.8,0]);
plot(lunar_SOI*cos(theta)+lunar_position2(1,end), lunar_SOI*sin(theta)+lunar_position2(2,end),'--','Color','k');
plot(0,0,'Marker','o','Color','b')
plot(388000,0,'Marker','o','Color',[0.8,0.8,0])
grid on
hold off
ylim([-3,3]*10^5);
xlim([-1,5]*10^5);

legend([p_trj,p_soi,p_pl],'trajectory',...
                          'Lunar SOI',...
                          'Lunar Orb',...
                          'Location','best')
title(['Earth Center','  (\theta=',num2str(theta2),'\circ)']);
xlabel("km");
ylabel("km");


subplot(2,1,2)
p_rr = plot(relative_position(1,:),relative_position(2,:));
hold on
p_rr2 = plot(relative_position2(1,:),relative_position2(2,:));
p_rr3 = plot(relative_position3(1,:),relative_position3(2,:));
p_rr4 = plot(relative_position4(1,:),relative_position4(2,:));

p_mm = plot(0,0,'Marker','o','Color',[0.8,0.8,0]);
p_m = plot((Rmission+R_lunar)*cos(theta),(Rmission+R_lunar)*sin(theta),'Color','b');
p_soi = plot(lunar_SOI*cos(theta), lunar_SOI*sin(theta),'--','Color','k');
hold off
title(['Moon Center']);
xlim([-7,7]*10^4);
ylim([-7,7]*10^4);
legend([p_rr,p_rr2,p_rr3,p_rr4,p_soi,p_m],['  \theta=',num2str(theta1),'\circ'],...
                                          ['  \theta=',num2str(theta2),'\circ'],...
                                          ['  \theta=',num2str(theta3),'\circ'],...
                                          ['  \theta=',num2str(theta4),'\circ'],...
                                          'Lunar soi', ...
                                          'Target Orb',...
                                          'Location','best')
grid on