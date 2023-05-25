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
lunar_position = [Lunar_orb.trans.pos(:,1:end-1),Lunar_orb.inj.pos,Lunar_orb.ex.pos];

result.delv1          =   Trans_orb.orb(4:6,1)-E_orb.v0';
result.delv2          =   LOI_orb.orb(4:6,1) - Trans_orb.orb(4:6,end);
result.delv3          =   M_orb.orb(4:6,1)   - LOI_orb.orb(4:6,end);
result.delvs          =   [norm(result.delv1),norm(result.delv2),norm(result.delv3)];

% Relative
relative_position = result.orb(1:3,:)-lunar_position;
relative_earthPosition = -lunar_position;

% Figure
fg          = figure();
fg.Position = [450,70,1080,820];

% Sub Plot 2
subplot(2,2,2);
p1 = plot(relative_position(1,:),relative_position(2,:),'Color','b');
hold on
p2 = plot(xl_mission,yl_mission,'--','Color','k');
p3 = plot(relative_earthPosition(1,:),relative_earthPosition(2,:),'Color','g');
plot(0,0,'Marker','o','Color',[0.7,0.7,0])
plot(lunar_SOI*cos(theta),lunar_SOI*sin(theta),'--','Color','k')
hold off
legend([p1,p2,p3],'Trajectory','Lunar SOI','Earth Orb')
xlabel('km');
ylabel('km');
title(['Moon Center','  (\theta=',num2str(theta_init*180/pi),'\circ)']);
grid on

% Sub Plot3
dt = IConditions.dt_rk89;
dn = vecnorm(relative_position);
ts = 0:dt:(length(result.orb)-1)*(dt);
subplot(2,2,3)
hold on
plot(ts/86400,dn);
hold off
yline(R_lunar+Rmission,'--','Label','Mission Orb');
xlabel('TOF (day)');ylabel('km');
ylim([-10000,max(dn)]);
title(['Distance From Moon','  (\theta=',num2str(theta_init*180/pi),'\circ)']);
grid on


% Sub Plot 4
subplot(2,2,4);
p11 = plot(relative_position(1,:),relative_position(2,:));
hold on
p33 = plot(0,0,'Marker','o','Color',[0.7,0.7,0]);
quiver3(M_orb.orb(1,1)-Lunar_orb.ex.pos(1,1),M_orb.orb(2,1)-Lunar_orb.ex.pos(2,1),M_orb.orb(3,1)--Lunar_orb.ex.pos(3,1),result.delv3(1),result.delv3(2),result.delv3(3),3e3','Color',[1,0.5,0.5],'LineWidth',1);
plot(lunar_SOI*cos(theta),lunar_SOI*sin(theta),'--')
text (-3000,-4000,{'\rightarrow : del v'},'color',[1,0.5,0.5])
hold off
legend([p11,p33],'Trajectory','Moon')
xlim([-1,1]*10^4);
ylim([-1,1]*10^4);
xlabel('km');
ylabel('km');
title(['Moon Center, Near','  (\theta=',num2str(theta_init*180/pi),'\circ)']);
grid on


% Sub Plot 1
subplot(2,2,1);
p_y = plot(result.orb(1,:),result.orb(2,:),'Color','b');
hold on
plot(0,0,'Marker','o','Color',[0,0.3,0])
p_l = plot(lunar_position(1,:),lunar_position(2,:));
plot(lunar_posATinj(1),lunar_posATinj(2),'Marker','O','Color',[0.7,0.7,0])
p_soi = plot(x_soi,y_soi,'--','Color','k');
delv1 = quiver3(Trans_orb.orb(1,1),Trans_orb.orb(2,1),Trans_orb.orb(3,1),result.delv1(1),result.delv1(2),result.delv1(3),5e4,'Color',[1,0.4,0.4]);
delv2 = quiver3(LOI_orb.orb(1,1),LOI_orb.orb(2,1),LOI_orb.orb(3,1),result.delv2(1),result.delv2(2),result.delv2(3),2e4','Color',[1,0.5,0.5]);
delv3 = quiver3(M_orb.orb(1,1),M_orb.orb(2,1),M_orb.orb(3,1),result.delv3(1),result.delv3(2),result.delv3(3),5e4','Color',[1,0.5,0.5],'LineWidth',1);
text (100000,-170000,{'\rightarrow : del v'},'color',[1,0.5,0.5])
legend([p_y,p_l,p_soi],'Trajectory','Lunar Orb','Lunar SOI')
grid on


title(['Earth Center','  (\theta=',num2str(theta_init*180/pi),'\circ)']);
xlim([-1,6]*10^5);xlabel('km');
ylim([-4,5]*10^5);ylabel('km');
shipWriter = animatedline('Color','r','Marker',".",'MarkerSize',15,'MarkerFaceColor','r','MaximumNumPoints',1,'HandleVisibility','off');
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',15,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',1,'HandleVisibility','off');
soi_writer = animatedline('Color','k','MaximumNumPoints',100,'LineStyle','--','MaximumNumPoints',100,'HandleVisibility','off');

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
