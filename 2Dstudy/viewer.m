<<<<<<< HEAD
% Lunar Orbit


% Sub Plot 2
theta = linspace(0,2*pi,1000);
lxx = (R_lunar+Rmission)*cos(theta);
lyy = (R_lunar+Rmission)*sin(theta);

yy = orb(1:3,:)-lunar_pos';
for i = 1:length(yy)
    yvv(:,i) = orb(4:6,i)-lunar_vel(i,:)';
end

subplot(2,2,2)
plot(yy(1,:),yy(2,:))
title('ME ( MJ2000 )')
hold on
plot(lxx,lyy,'--')
hold off
xlim([-7,1]*10^4)
ylim([-1,1]*10^4)
grid on

% Sub Plot3
subplot(2,2,3)
plot(yvv(1,:),yvv(2,:))
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
xlim([-1,5]*10^5);
ylim([-1,4]*10^5);
grid on


for k = 1:100:length(orb)-99
    xvec = orb(1,k:k+99);
    yvec = orb(2,k:k+99);
    zvec = orb(3,k:k+99);

    lunarx = lunar_pos(k:k+99,1);
    lunary = lunar_pos(k:k+99,2);
    lunarz = lunar_pos(k:k+99,3);
=======
% Lunar SOI
theta = linspace(0,2*pi,1000);
x_soi = lunar_SOI*cos(theta)+lunar_posATinj(1);
y_soi = lunar_SOI*sin(theta)+lunar_posATinj(2);

xe_mission = (Rmission+R_lunar)*cos(theta)+lunar_posATinj(1);
ye_mission = (Rmission+R_lunar)*sin(theta)+lunar_posATinj(2);

xl_mission = (Rmission+R_lunar)*cos(theta);
yl_mission = (Rmission+R_lunar)*sin(theta);

% Relative
for i = 1:length(lunar_position)
    relative_position(:,i) = y_loi(1:3,i)-lunar_position(:,i);
    relative_velocity(:,i) = y_loi(4:6,i)-lunar_velocity(:,i);
end



% Figure
fg = figure("Color",[0.15,0.15,0.15]);
fg.Position = [500,200,960,720];
subplot(2,2,2);
plot(relative_position(1,:),relative_position(2,:),'Color','White')
hold on
plot(xl_mission,yl_mission,'--')
plot(0,0,'Marker','o')
xlim([-2,2]*10^4);
ylim([-2,2]*10^4)
set(gca,'color',[0.2,0.2,0.2],'XColor',[0.8,0.8,0.8],'YColor',[0.8,0.8,0.8])
hold off
grid on


% 
subplot(2,2,1);
plot(y(1,:),y(2,:),'Color','White')
hold on
plot(0,0,'Marker','o','Color','g')
plot(lunar_position(1,:),lunar_position(2,:))
plot(lunar_posATinj(1),lunar_posATinj(2),'Marker','o','Color','Y')
plot(x_soi,y_soi,'--','Color','w')
plot(xe_mission,ye_mission,'--','Color','w')
text(x_soi(1),y_soi(1),{' Lunar',' SOI'},'color','White')

set(gca,'color',[0.2,0.2,0.2],'XColor',[0.8,0.8,0.8],'YColor',[0.8,0.8,0.8])
grid on
xlim([-1,5]*10^5);
ylim([-4,4]*10^5);

shipWriter = animatedline('Color','r','Marker',".",'MarkerSize',15,'MarkerFaceColor','r','MaximumNumPoints',100);
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',15,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',10);
for k = 1:100:length(y_loi)-99
    xvec = y_loi(1,k:k+99);
    yvec = y_loi(2,k:k+99);
    zvec = y_loi(3,k:k+99);

    lunarx = lunar_position(1,k:k+99);
    lunary = lunar_position(2,k:k+99);
    lunarz = lunar_position(3,k:k+99);
>>>>>>> main

    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    drawnow
end

<<<<<<< HEAD

=======
hold off
>>>>>>> main
