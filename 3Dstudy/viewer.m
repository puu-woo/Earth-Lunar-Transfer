function viewer(results, saveMode)

% Variables
IConditions = results.IConditions;

dt_transer = results.IConditions.dt_rk89;
dt_mission = results.IConditions.dt_rk4;

transfer_orb = results.transferOrb;
mission_orb = results.missionOrb;
total_orb = results.totalOrb;

lunarOrb_atTrans = results.lunarOrb_atTrans;
lunarOrb_atManeuver = results.lunarOrb_atMission;
lunarOrb = results.totalLunarOrb;

TOF_transfer = results.TOF(1);
TOF_maneuver = results.TOF(2);

total_LunarOrb = results.totalLunarOrb;
relative_pos = total_orb(1:3,:) - total_LunarOrb(1:3,:);

% Mission Orbit boundary
theta = linspace(0,2*pi,100);
H = IConditions.Lunar.h_mission;
H_x = H*cos(theta);
H_y = H*sin(theta);

% Lunar
R_lunar = IConditions.Lunar.R;
[X,Y,Z] = sphere();
X = R_lunar*X;
Y = R_lunar*Y;
Z = R_lunar*Z;

fg = figure(1);
fg.Position = [400,150,1280,720];

% Sub Plot 2
subplot(2,3,2)
plot3(relative_pos(1,:),relative_pos(2,:),relative_pos(3,:),'DisplayName','trajectory')
hold on
surf(X,Y,Z,'FaceColor',[0.7,0.7,0.7],'EdgeColor','none','DisplayName',"Lunar")
hold off
title("Moon Center");
grid on
xlabel("km");
ylabel("km");
zlabel("km");
legend("Location","north")

% Sub Plot 3
subplot(2,3,3)
plot3(relative_pos(1,:),relative_pos(2,:),relative_pos(3,:),'DisplayName',"trajectory");
hold on
surf(X,Y,Z,'FaceColor',[0.7,0.7,0.7],'EdgeColor','none','DisplayName',"Lunar")
hold off

xlabel("km")
legend("Location","best");
grid on
title("Moon Center, near");
xlim([-5,5]*10^3)
ylim([-5,5]*10^3)
zlim([-5,5]*10^3)
xlabel("km");
ylabel("km");
zlabel("km");

% Sub Plot4
subplot(2,3,4)
tspace1 = 0:dt_transer:TOF_transfer;
tspace2 = TOF_transfer:dt_mission:TOF_transfer+TOF_maneuver;

Rel_pos1 = transfer_orb(1:3,:)-lunarOrb_atTrans(1:3,:);
Rel_pos2 = mission_orb(1:3,:)-lunarOrb_atManeuver(1:3,:);

plot(tspace1/86400,vecnorm(Rel_pos1),'Color','b','DisplayName','distance from moon center');
hold on
plot(tspace2/86400,vecnorm(Rel_pos2),'Color','b','HandleVisibility','off');
hold off
title("Distance From Moon")
grid on
% ylim([1840,1850])
xlabel("day");
ylabel("km");
legend();


% Sub Plot 5
subplot(2,3,5)
plot(tspace2/86400,vecnorm(results.earth_gravity)*1000,'DisplayName','earth gravity')
hold on
plot(tspace2/86400,vecnorm(results.lunar_gravity)*1000,'DisplayName','lunar gravity')
hold off
grid on
xlabel("day");
ylabel("m/s^2");
title("Gravity")
ylim([-0.5,2])
legend("Location","best");

% SubPlot 6
% Offset from target
subplot(2,3,6)
plot((tspace2-tspace2(1))/86400,vecnorm(Rel_pos2)-IConditions.Lunar.h_mission,'Color','b','HandleVisibility','off');
grid on
title("Offset from target")
xlabel("day")
ylabel("offset [km]")

% Sub Plot 1
subplot(2,3,1)
plot3(total_orb(1,:),total_orb(2,:),total_orb(3,:),'DisplayName','sat trajectory')
hold on
plot3(lunarOrb(1,:),lunarOrb(2,:),lunarOrb(3,:),'DisplayName','lunar trajectory')
hold off
grid on
xlim([-6,6]*10^5);
ylim([-6,6]*10^5);
zlim([-6,6]*10^5);
title("Earth Center");
xlabel("km");
ylabel("km");
zlabel("km");
legend("Location","best");

shipWriter = animatedline('Color','r','Marker',".",'MarkerSize',15,'MarkerFaceColor','r','MaximumNumPoints',1,'HandleVisibility','off');
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',15,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',1,'HandleVisibility','off');
soi_writer = animatedline('Color','w','MaximumNumPoints',100,'LineStyle','--','MaximumNumPoints',100,'HandleVisibility','off');

speed = 3600;
for k = 1:speed/dt_transer:length(transfer_orb)-(speed/dt_transer-1)
    xvec = total_orb(1,k);
    yvec = total_orb(2,k);
    zvec = total_orb(3,k);

    lunarx = lunarOrb(1,k);
    lunary = lunarOrb(2,k);
    lunarz = lunarOrb(3,k);


    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    drawnow

    if saveMode == 1
        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if k==1
            imwrite(imind,cm,'EarthCenter.gif','gif','Loopcount',inf);
        else
            imwrite(imind,cm,'EarthCenter.gif','gif','DelayTime',0,'WriteMode','append');
        end
    end
    
end


for k = length(transfer_orb):speed/dt_mission:length(total_orb)-(speed/dt_mission-1)
    xvec = total_orb(1,k);
    yvec = total_orb(2,k);
    zvec = total_orb(3,k);

    lunarx = lunarOrb(1,k);
    lunary = lunarOrb(2,k);
    lunarz = lunarOrb(3,k);


    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    drawnow
    if saveMode == 1
        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if k==1
            imwrite(imind,cm,'EarthCenter.gif','gif','Loopcount',inf);
        else
            imwrite(imind,cm,'EarthCenter.gif','gif','DelayTime',0,'WriteMode','append');
        end
    end
end

hold off

end