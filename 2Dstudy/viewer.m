% Lunar Orbit
theta = linspace(0,2*pi,1000);
E_x = R_earth*cos(theta);
E_y = R_earth*sin(theta);
L_x = R_lunar*cos(theta)+lunar_distance;
L_y = R_lunar*sin(theta);
L_SOI_x = lunar_SOI*cos(theta)+lunar_distance;
L_SOI_y = lunar_SOI*sin(theta);
ndelv = norm(delv(1,:))+norm(delv(2,:))+norm(delv(3,:))
rr_mci = orb(1:3,:)-lunar_pos(:,:)';

for i = 1:K
    dd_mci(i) = norm(rr_mci(:,i));
end

fg = figure(1);
fg.Position = [500 150 960 720];



% Sub Plot 2
theta = linspace(0,2*pi,1000);
lxx = (R_lunar+Rmission)*cos(theta);
lyy = (R_lunar+Rmission)*sin(theta);

for i = 1:length(rr_mci)
    yvv(:,i) = orb(4:6,i)-lunar_vel(i,:)';
end

subplot(2,2,2)
plot(rr_mci(1,:),rr_mci(2,:))
title('MCI (B-Plane)')
hold on
plot(lxx,lyy,'--')
hold off
xlabel('km');
ylabel('km');
xlim([-7,1]*10^4)
ylim([-1,1]*10^4)
grid on

% Sub Plot3
subplot(2,2,3)
plot(yvv(1,:),yvv(2,:))
title('velocity MCI')
xlabel('Vx - km/s');
ylabel('Vy - km/s');
grid on

% Sub Plot4
for i = 1:K
    ts(i) = i*5;
end
subplot(2,2,4)
plot(ts,dd_mci-R_lunar)
xlabel('sec');
ylabel('km');
ylim([-1000,1200])
yline(100,'--','Label','100km')
title('Distance')
grid on

% Sub Plot 1
sub2 = subplot(2,2,1);
title('J2000')
shipWriter = animatedline('Color','r','Marker',".",'LineWidth',5,'MarkerFaceColor','r','MaximumNumPoints',100);
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',10,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',10);


hold on
plot(lunar_pos(:,1),lunar_pos(:,2))
plot(orb(1,:),orb(2,:))
plot(E_x,E_y,'--')
plot(L_x,L_y,'--')
plot(L_SOI_x,L_SOI_y,'--')
hold off
xlabel('km');
ylabel('km');
xlim([-1,5]*10^5);
ylim([-4,4]*10^5);
grid on


for k = 1:500:length(orb)-499
    xvec = orb(1,k:k+499);
    yvec = orb(2,k:k+499);
    zvec = orb(3,k:k+499);

    lunarx = lunar_pos(k:k+499,1);
    lunary = lunar_pos(k:k+499,2);
    lunarz = lunar_pos(k:k+499,3);

    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    drawnow
end


