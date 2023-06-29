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
fg          = figure("Color",[0.15,0.15,0.15]);
fg.Position = [500,80,960,720];
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

    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    drawnow
end

hold off
