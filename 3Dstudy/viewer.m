relative_pos = orb.orb(1:3,:) - Lunar_orb.orb(1:3,:);


theta = linspace(0,2*pi,100);
H = R_lunar+100;
H_x = H*cos(theta);
H_y = H*sin(theta);

[X,Y,Z] = sphere();
X = H*X;
Y = H*Y;
Z = H*Z;
fg = figure(1);
fg.Position = [500,150,960,720];

% Sub Plot 2
subplot(2,2,2)
plot3(relative_pos(1,:),relative_pos(2,:),relative_pos(3,:))
hold on
plot(H_x,H_y,'k--')
hold off
title("Moon Center");
grid on


% Sub Plot3
subplot(2,2,3)
tspace1 = 0:IConditions.dt_rk89:trans_orb.T;
tspace2 = trans_orb.T:IConditions.dt2_rk89:trans_orb.T+mission_orb.T;
Rel_pos1 = trans_orb.orb(1:3,:)-Lunar_orb_trans.orb(1:3,:);
Rel_pos2 = mission_orb.orb(1:3,:)-Lunar_orb_mission.orb(1:3,:);

plot(tspace1/86400,vecnorm(Rel_pos1),'Color','b');
hold on
plot(tspace2/86400,vecnorm(Rel_pos2),'Color','b');
hold off
title("Distance From Moon")
grid on


% Sub Plot 4
subplot(2,2,4)
plot3(relative_pos(1,:),relative_pos(2,:),relative_pos(3,:),'DisplayName',"trajectory");
hold on
surf(X,Y,Z,'FaceColor',[0.7,0.7,0.7],'EdgeColor','none','DisplayName',"Lunar")
hold off

legend("Location","best");

grid on
title("Moon Center, near");
xlim([-5,5]*10^3)
ylim([-5,5]*10^3)
zlim([-5,5]*10^3)


% Sub Plot 1
subplot(2,2,1)
plot3(orb.orb(1,:),orb.orb(2,:),orb.orb(3,:))
hold on
plot3(Lunar_orb.orb(1,:),Lunar_orb.orb(2,:),Lunar_orb.orb(3,:))
hold off
grid on
xlim([-6,6]*10^5);
ylim([-6,6]*10^5);
zlim([-6,6]*10^5);
title("Earth Center");

shipWriter = animatedline('Color','r','Marker',".",'MarkerSize',15,'MarkerFaceColor','r','MaximumNumPoints',1,'HandleVisibility','off');
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',15,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',1,'HandleVisibility','off');
soi_writer = animatedline('Color','w','MaximumNumPoints',100,'LineStyle','--','MaximumNumPoints',100,'HandleVisibility','off');

speed = 3600;
for k = 1:speed/IConditions.dt_rk89:length(trans_orb.orb)-(speed/IConditions.dt_rk89-1)
    xvec = orb.orb(1,k);
    yvec = orb.orb(2,k);
    zvec = orb.orb(3,k);

    lunarx = Lunar_orb.orb(1,k);
    lunary = Lunar_orb.orb(2,k);
    lunarz = Lunar_orb.orb(3,k);


    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    drawnow

% %     frame = getframe(1);
% %     im = frame2im(frame);
% %     [imind,cm] = rgb2ind(im,256);
% %     if k==1
% %         imwrite(imind,cm,'EarthCenter.gif','gif','Loopcount',inf);
% %     else
% %         imwrite(imind,cm,'EarthCenter.gif','gif','DelayTime',0,'WriteMode','append');
% %     end
end


for k = length(trans_orb.orb):speed/IConditions.dt2_rk89:length(orb.orb)-(speed/IConditions.dt2_rk89-1)
    xvec = orb.orb(1,k);
    yvec = orb.orb(2,k);
    zvec = orb.orb(3,k);

    lunarx = Lunar_orb.orb(1,k);
    lunary = Lunar_orb.orb(2,k);
    lunarz = Lunar_orb.orb(3,k);


    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    drawnow

% %     frame = getframe(1);
% %     im = frame2im(frame);
% %     [imind,cm] = rgb2ind(im,256);
% %     if k==1
% %         imwrite(imind,cm,'EarthCenter.gif','gif','Loopcount',inf);
% %     else
% %         imwrite(imind,cm,'EarthCenter.gif','gif','DelayTime',0,'WriteMode','append');
% %     end
end

hold off