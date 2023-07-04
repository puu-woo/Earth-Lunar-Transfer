function saver(results, saveMode)

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

plot3(total_orb(1,:),total_orb(2,:),total_orb(3,:),'DisplayName','sat trajectory')
hold on
plot3(lunarOrb(1,:),lunarOrb(2,:),lunarOrb(3,:),'DisplayName','lunar trajectory')
hold off
grid on
view(65,45)
xlim([-2,4]*10^5);
ylim([-1.5,4.5]*10^5);
zlim([-1,5]*10^5);
title("Earth Center");
xlabel("km");
ylabel("km");
zlabel("km");
legend("Location","best");
set(gcf,'color',[1,1,1]);

shipWriter = animatedline('Color','r','Marker',".",'MarkerSize',11,'MarkerFaceColor','r','MaximumNumPoints',1,'HandleVisibility','off');
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',13,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',1,'HandleVisibility','off');

speed = 60*110;
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
            imwrite(imind,cm,'EarthCenter.gif','gif','DelayTime',0.06,'WriteMode','append');
        end
    end
    
end

speed = speed*0.9;
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
        imwrite(imind,cm,'EarthCenter.gif','gif','DelayTime',0.06,'WriteMode','append');

    end
end

hold off

end