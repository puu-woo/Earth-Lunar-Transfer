% Lunar SOI
theta = linspace(0,2*pi,100);
x_soi = lunar_SOI*cos(theta)+lunar_posATinj(1);
y_soi = lunar_SOI*sin(theta)+lunar_posATinj(2);

xe_mission = (Rmission+R_lunar)*cos(theta)+lunar_posATinj(1);
ye_mission = (Rmission+R_lunar)*sin(theta)+lunar_posATinj(2);

xl_mission = (Rmission+R_lunar)*cos(theta);
yl_mission = (Rmission+R_lunar)*sin(theta);


% Tricky Lunar position at transfer time
lunar_w         =   [0,0,2*pi / (27*24*3600)];
l = length(y_trans);
lunar_position(:,l+1) = lunar_posATinj;
lunar_velocity(:,l+1) = cross(lunar_w,lunar_posATinj);

for i = 1:l
    lunar_position(:,l+1-i) = lunar_position(:,l+2-i) - lunar_velocity(:,l+2-i)*dt';
    lunar_velocity(:,l+1-i) = cross(lunar_w,lunar_position(:,l+2-i))';
end

% All lunar position
lunar_position2 = [lunar_position(:,1:end-1),lunar_position_inj];
% lunar_velocity2 = [lunar_velocity(:,1:end-1),lunar_velocity_inj];


% Relative
relative_position = y(1:3,:)-lunar_position2;
% relative_velocity = y(4:6,:)-lunar_velocity2;
relative_earthPosition = -lunar_position2;

% Figure
fg          = figure("Color",[0.15,0.15,0.15]);
fg.Position = [450,70,1080,820];

% Sub Plot 2
subplot(2,2,2);
p1 = plot(relative_position(1,:),relative_position(2,:),'Color','White');
hold on
p2 = plot(xl_mission,yl_mission,'--','Color','w');
p3 = plot(relative_earthPosition(1,:),relative_earthPosition(2,:),'Color','g');
plot(0,0,'Marker','o','Color','y')
plot(lunar_SOI*cos(theta),lunar_SOI*sin(theta),'--','Color','w')
hold off
legend([p1,p2,p3],'Trajectory','Lunar SOI','Earth Orb','Color',[0.2,0.2,0.2],'TextColor','w')
% xlim([-2,2]*10^4);
% ylim([-2,2]*10^4);
xlabel('km');
ylabel('km');
title(['Lunar Center','  (\theta=',num2str(theta_init*180/pi),'\circ)'],Color='white');
set(gca,'color',[0.2,0.2,0.2],'XColor',[0.8,0.8,0.8],'YColor',[0.8,0.8,0.8])
grid on

% Sub Plot3
dn = vecnorm(relative_position);
ts = 0:dt:(length(y)-1)*(dt);
subplot(2,2,3)
plot(ts/86400,dn,'Color','w');
yline(R_lunar+Rmission,'--','Color','w','Label','Mission Orb');
xlabel('TOF (day)');ylabel('km');ylim([-10000,max(dn)]);
title(['Distance From Lunar','  (\theta=',num2str(theta_init*180/pi),'\circ)'],Color='w');
grid on
set(gca,'color',[0.2,0.2,0.2],'XColor',[0.8,0.8,0.8],'YColor',[0.8,0.8,0.8])

% Sub Plot 4
subplot(2,2,4);
p11 = plot(relative_position(1,:),relative_position(2,:),'Color','White');
hold on
p22 = plot(xl_mission,yl_mission,'--','Color','w');
p33 = plot(0,0,'Marker','o','Color','y');
plot(lunar_SOI*cos(theta),lunar_SOI*sin(theta),'--','Color','w')
hold off
legend([p11,p22,p33],'Trajectory','Mission Orb','Moon','Color',[0.2,0.2,0.2],'TextColor','w')
xlim([-1,1]*10^4);
ylim([-1,1]*10^4);
xlabel('km');
ylabel('km');
title(['Lunar Center, Near Lunar','  (\theta=',num2str(theta_init*180/pi),'\circ)'],Color='white');
set(gca,'color',[0.2,0.2,0.2],'XColor',[0.8,0.8,0.8],'YColor',[0.8,0.8,0.8])
grid on


% Sub Plot 1
subplot(2,2,1);
p_y = plot(y(1,:),y(2,:),'Color','White');
hold on
plot(0,0,'Marker','o','Color','g')
p_l = plot(lunar_position2(1,:),lunar_position2(2,:));
plot(lunar_posATinj(1),lunar_posATinj(2),'Marker','O','Color','Y')
p_soi = plot(x_soi,y_soi,'--','Color','w');
plot(xe_mission,ye_mission,'--','Color','w')
delv1 = quiver3(y_trans(1,1),y_trans(2,1),y_trans(3,1),(y_trans(4,1)-v0(1)),(y_trans(5,1)-v0(2)),(y_trans(6,1)-v0(3)),2e4,'Color',[1,0.4,0.4]);
delv2 = quiver3(y_loi(1,1),y_loi(2,1),y_loi(3,1),(y_loi(4,1)-y_trans(4,end)),(y_loi(5,1)-y_trans(5,end)),(y_loi(6,1)-y_trans(6,end)),2e4','Color',[1,0.5,0.5]);
% text(x_soi(1),y_soi(1),{' Lunar',' SOI'},'color','White')
text (0,-150000,{'\rightarrow : del v'},'color',[1,0.5,0.5])
set(gca,'color',[0.2,0.2,0.2],'XColor',[0.8,0.8,0.8],'YColor',[0.8,0.8,0.8])
legend([p_y,p_l,p_soi],'Trajectory','Lunar Orb','Lunar SOI','Color',[0.2,0.2,0.2],'TextColor','w')
grid on


title(['Earth Center','  (\theta=',num2str(theta_init*180/pi),'\circ)'],Color='white');
xlim([-1,6]*10^5);xlabel('km');
ylim([-4,5]*10^5);ylabel('km');

shipWriter = animatedline('Color','r','Marker',".",'MarkerSize',15,'MarkerFaceColor','r','MaximumNumPoints',1,'HandleVisibility','off');
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',15,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',1,'HandleVisibility','off');
soi_writer = animatedline('Color','w','MaximumNumPoints',100,'LineStyle','--','MaximumNumPoints',100,'HandleVisibility','off');

speed = 300;
for k = 1:speed:length(y)-(speed-1)
    xvec = y(1,k);
    yvec = y(2,k);
    zvec = y(3,k);

    lunarx = lunar_position2(1,k);
    lunary = lunar_position2(2,k);
    lunarz = lunar_position2(3,k);

    soix = lunar_SOI*cos(theta)+lunar_position2(1,k);
    soiy = lunar_SOI*sin(theta)+lunar_position2(2,k);
    soiz = 0*sin(theta)+lunar_position2(3,k);

    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    addpoints(soi_writer,soix,soiy,soiz)
    drawnow
end

hold off
