% Lunar SOI
theta = linspace(0,2*pi,100);
x_soi = lunar_SOI*cos(theta)+lunar_posATinj(1);
y_soi = lunar_SOI*sin(theta)+lunar_posATinj(2);

xe_mission = (Rmission+R_lunar)*cos(theta)+lunar_posATinj(1);
ye_mission = (Rmission+R_lunar)*sin(theta)+lunar_posATinj(2);

xl_mission = (Rmission+R_lunar)*cos(theta);
yl_mission = (Rmission+R_lunar)*sin(theta);

theta_init = IConditions.Earth.theta;

% All lunar position
lunar_position = [Lunar_orb.trans.pos(:,1:end-1),Lunar_orb.inj.pos];

result.delv1          =   Trans_orb.orb(4:6,1)-E_orb.v0';
result.delv2          =   LOI_orb.orb(4:6,1) - Trans_orb.orb(4:6,end);
% result.delv3          =   M_orb.orb(4:6,1)   - LOI_orb.orb(4:6,end);
% result.delvs          =   [norm(result.delv1),norm(result.delv2),norm(result.delv3)];

% Relative
relative_position = result.orb(1:3,:)-lunar_position;
relative_earthPosition = -lunar_position;

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
xlabel('km');
ylabel('km');
title(['Lunar Center','  (\theta=',num2str(theta_init*180/pi),'\circ)'],Color='white');
set(gca,'color',[0.2,0.2,0.2],'XColor',[0.8,0.8,0.8],'YColor',[0.8,0.8,0.8])
grid on

% Sub Plot3
dn = vecnorm(relative_position);
ts = 0:dt:(length(result.orb)-1)*(dt);
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
% quiver3(M_orb.orb(1,1)-Lunar_orb.ex.pos(1,1),M_orb.orb(2,1)-Lunar_orb.ex.pos(2,1),M_orb.orb(3,1)--Lunar_orb.ex.pos(3,1),result.delv3(1),result.delv3(2),result.delv3(3),3e3','Color',[1,0.5,0.5],'LineWidth',1);
plot(lunar_SOI*cos(theta),lunar_SOI*sin(theta),'--','Color','w')
text (-3000,-4000,{'\rightarrow : del v'},'color',[1,0.5,0.5])
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
p_y = plot(result.orb(1,:),result.orb(2,:),'Color','White');
hold on
plot(0,0,'Marker','o','Color','g')
p_l = plot(lunar_position(1,:),lunar_position(2,:));
plot(lunar_posATinj(1),lunar_posATinj(2),'Marker','O','Color','Y')
p_soi = plot(x_soi,y_soi,'--','Color','w');
plot(xe_mission,ye_mission,'--','Color','w')
% delv1 = quiver3(Trans_orb.orb(1,1),Trans_orb.orb(2,1),Trans_orb.orb(3,1),result.delv1(1),result.delv1(2),result.delv1(3),5e4,'Color',[1,0.4,0.4]);
% delv2 = quiver3(LOI_orb.orb(1,1),LOI_orb.orb(2,1),LOI_orb.orb(3,1),result.delv2(1),result.delv2(2),result.delv2(3),2e4','Color',[1,0.5,0.5]);
% delv3 = quiver3(M_orb.orb(1,1),M_orb.orb(2,1),M_orb.orb(3,1),result.delv3(1),result.delv3(2),result.delv3(3),5e4','Color',[1,0.5,0.5],'LineWidth',1);
text (100000,-170000,{'\rightarrow : del v'},'color',[1,0.5,0.5])
set(gca,'color',[0.2,0.2,0.2],'XColor',[0.8,0.8,0.8],'YColor',[0.8,0.8,0.8])
legend([p_y,p_l,p_soi],'Trajectory','Lunar Orb','Lunar SOI','Color',[0.2,0.2,0.2],'TextColor','w')
grid on


title(['Earth Center','  (\theta=',num2str(theta_init*180/pi),'\circ)'],Color='white');
xlim([-1,6]*10^5);xlabel('km');
ylim([-4,5]*10^5);ylabel('km');
shipWriter = animatedline('Color','r','Marker',".",'MarkerSize',15,'MarkerFaceColor','r','MaximumNumPoints',1,'HandleVisibility','off');
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',15,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',1,'HandleVisibility','off');
soi_writer = animatedline('Color','w','MaximumNumPoints',100,'LineStyle','--','MaximumNumPoints',100,'HandleVisibility','off');

speed = 500;
for k = 1:speed:length(result.orb)-(speed-1)
    xvec = result.orb(1,k);
    yvec = result.orb(2,k);
    zvec = result.orb(3,k);

    lunarx = lunar_position(1,k);
    lunary = lunar_position(2,k);
    lunarz = lunar_position(3,k);

    soix = lunar_SOI*cos(theta)+lunar_position(1,k);
    soiy = lunar_SOI*sin(theta)+lunar_position(2,k);
    soiz = 0*sin(theta)+lunar_position(3,k);

    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    addpoints(soi_writer,soix,soiy,soiz)
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
