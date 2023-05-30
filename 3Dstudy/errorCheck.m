

% r0 = IConditions.Earth.r0;
% v0 = IConditions.Earth.v0;

r0 = mission_orb.orb(1:3,1);
v0 = mission_orb.orb(4:6,1);

% [Trans_orb2,Lunar_orb_trans2, min_distance] = orbitRK89([r0;v0],IConditions,Lunar_orb_trans.orb(1:3,end),"transfer");
IConditions.dt_rk4 = 0.1;
[Trans_orb2,Lunar_orb_trans2] = orbitRK4([r0;v0],IConditions,Lunar_orb_trans.orb(1:3,end));

r = zeros(3,length(Trans_orb2.orb));
rn = norm(r0-Lunar_orb_trans.orb(1:3,end));
theta = linspace(0,2*pi,length(Trans_orb2.orb));

r(1,:) = rn*cos(theta);
r(2,:) = rn*sin(theta);
r(3,:) = 0*sin(theta);

% raan                 =   0 * pi / 180;
% inc                  =   45 * pi / 180;
% w                    =   180 * pi / 180;

raan = mission_orb.oev(5);
inc = mission_orb.oev(3);
w = mission_orb.oev(4)+mission_orb.oev(6);

DCM_w = [ cos(-w),     sin(-w),     0;
         -sin(-w),    cos(-w),     0;
         0,               0,             1];

DCM_inc = [1 , 0 , 0;
        0 , cos(-inc), sin(-inc);
        0 , -sin(-inc), cos(-inc) ];

DCM_raan = [ cos(-raan),     sin(-raan),     0;
            -sin(-raan),    cos(-raan),     0;
            0,               0,             1];

r = DCM_raan*DCM_inc*DCM_w*r;

fg = figure(1);
fg.Position = [500,300,920,360];
subplot(1,2,1)
plot3(Trans_orb2.orb(1,:)-Lunar_orb_trans2.orb(1,:),Trans_orb2.orb(2,:)-Lunar_orb_trans2.orb(2,:),Trans_orb2.orb(3,:)-Lunar_orb_trans2.orb(3,:),'DisplayName','numer')
hold on
plot3(r(1,:),r(2,:),r(3,:),'DisplayName','absol');
hold off
grid on
xlabel("km")
ylabel("km")
legend('Location','best');

subplot(1,2,2)
tn = linspace(0,length(r)*IConditions.dt_rk4,length(r));
plot(tn/86400,vecnorm(r) - vecnorm(Trans_orb2.orb(1:3,:)-Lunar_orb_trans2.orb(1:3,:)))
grid on
ylabel(" error (km) ")
xlabel(" day ")