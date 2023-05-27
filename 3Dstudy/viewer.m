relative_pos = Trans_orb.orb(1:3,:) - Lunar_orb.pos;


theta = linspace(0,2*pi,100);
soi = R_lunar+100;
soi_x = soi*cos(theta);
soi_y = soi*sin(theta);

fg = figure(1);
fg.Position = [500,150,960,720];
% Sub Plot 2
subplot(2,2,2)
plot3(relative_pos(1,:),relative_pos(2,:),relative_pos(3,:))
hold on
plot3(soi_x,soi_y,zeros(length(soi_x)),'k--')
plot3(soi_x,zeros(length(soi_x)),soi_y,'k--')
plot3(zeros(length(soi_x)),soi_x,soi_y,'k--')
hold off

grid on
xlim([-5,5]*10^3)
ylim([-5,5]*10^3)
zlim([-5,5]*10^3)


% Sub Plot 1
subplot(2,2,1)
plot3(Trans_orb.orb(1,:),Trans_orb.orb(2,:),Trans_orb.orb(3,:))
hold on
plot3(Lunar_orb.pos(1,:),Lunar_orb.pos(2,:),Lunar_orb.pos(3,:))
hold off
grid on



shipWriter = animatedline('Color','r','Marker',".",'MarkerSize',15,'MarkerFaceColor','r','MaximumNumPoints',1,'HandleVisibility','off');
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',15,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',1,'HandleVisibility','off');
soi_writer = animatedline('Color','w','MaximumNumPoints',100,'LineStyle','--','MaximumNumPoints',100,'HandleVisibility','off');

speed = 30;
for k = 1:speed:length(Trans_orb.orb)-(speed-1)
    xvec = Trans_orb.orb(1,k);
    yvec = Trans_orb.orb(2,k);
    zvec = Trans_orb.orb(3,k);

    lunarx = Lunar_orb.pos(1,k);
    lunary = Lunar_orb.pos(2,k);
    lunarz = Lunar_orb.pos(3,k);


    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    drawnow

%     frame = getframe(1);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,256);
%     if k==1
%         imwrite(imind,cm,'EarthCenter.gif','gif','Loopcount',inf);
%     else
%         imwrite(imind,cm,'EarthCenter.gif','gif','DelayTime',0,'WriteMode','append');
%     end
end

hold off