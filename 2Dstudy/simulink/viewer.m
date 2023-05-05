% Viewer

theta = linspace(0,2*pi,1000);
E_x = R_earth*cos(theta);   
E_y = R_earth*sin(theta);
L_x = R_lunar*cos(theta)+lunar_distance;
L_y = R_lunar*sin(theta);
L_SOI_x = lunar_SOI*cos(theta)+lunar_distance;
L_SOI_y = lunar_SOI*sin(theta);
lxx = (R_lunar+Rmission)*cos(theta);
lyy = (R_lunar+Rmission)*sin(theta);

fg = figure(1);
fg.Position = [500 150 960 720];

% sub plot 2
subplot(2,2,2)
plot(orb_mci(:,1),orb_mci(:,2))
hold on
plot(lxx,lyy,'--')
hold off
title('MCI')
xlabel('km');
ylabel('km');
grid on
xlim([-4,4]*10^3);
ylim([-4,4]*10^3)

% sub plot 3
subplot(2,2,3)
length(timespace)
for i = 1:length(timespace)
    relative_distance(i) = norm(orb_mci(i,1:3));
    relative_velocity(i) = norm(orb_mci(i,4:6));
end
plot(timespace,relative_distance-R_lunar)
title('Distance from Target orbit')
yline(100,'--','Label','100km');
xlim([4*10^5, timespace(end)+10^4]);
ylim([80,120]);
xlabel('sec');
ylabel('km');
grid on

% Sub Plot 4
subplot(2,2,4)
plot(timespace,relative_velocity)
title('Relative Velocity')
yline(100,'--','Label','100km');
xlim([4.8*10^5, timespace(end)+10^4]);
ylim([min(relative_velocity(fix((T_trans+T_inj)/dt):end))-0.2, max(relative_velocity(fix((T_trans+T_inj)/dt):end))+0.1]);
yline(v_need,'Label','V mission orb')
xlabel('sec');
ylabel('km/s');
grid on

% sub plot 1
subplot(2,2,1)
shipWriter = animatedline('Color','r','Marker',".",'LineWidth',5,'MarkerFaceColor','r','MaximumNumPoints',100);
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',10,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',10);

hold on
plot(orb_eci(:,1),orb_eci(:,2))
plot(lpos(:,1),lpos(:,2))
hold off
title('ECI')
xlim([-1,5]*10^5);
ylim([-4,4]*10^5);
xlabel('km');
ylabel('km');
grid on

for k = 1:500:length(orb_eci)-499
    xvec = orb_eci(k:k+499,1);
    yvec = orb_eci(k:k+499,2);

    lunarx = lpos(k:k+499,1);
    lunary = lpos(k:k+499,2);

    addpoints(shipWriter,xvec,yvec)
    addpoints(moon_writer,lunarx,lunary)
    drawnow
end