format long
clear

out = sim("testsim2.slx");
time = out.position.Time;
pos = out.position.Data;
vel = out.velocity.Data;
lunar_trajectory = out.lunar_trajectory.Data;


% Earth
[X,Y,Z]             =   sphere;
X_E                 =   X * 6400;
Y_E                 =   Y * 6400;
Z_E                 =   Z * 6400;

X_M                 =   X * 1700+lunar_pos(1);
Y_M                 =   Y * 1700+lunar_pos(2);
Z_M                 =   Z * 1700+lunar_pos(3);


h = animatedline('Color','r');
shipWriter = animatedline('Color','r','Marker',".",'LineWidth',5,'MarkerFaceColor','r','MaximumNumPoints',100);
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',10,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',10);






i = round(T_trans / dt);
j = round((T_trans + T_injec+t4) / dt );
view([0 10])
xlim([-4,4]*10^5); xlabel('x');
ylim([-4,4]*10^5); ylabel('y');
zlim([-4,4]*10^5); zlabel('z');
hold on
plot3( 0,0,0,'Marker','o','MarkerFaceColor',[0,0.7,1])
surf( X_M , Y_M , Z_M , 'FaceColor' , [1,0.7,0] , 'EdgeColor' , [ 1 , 0.5 , 0 ] );
plot3( lunar_orb(1,:),lunar_orb(2,:),lunar_orb(3,:),'Color',[1,0.8,0])
% quiver3( pos(i,1),pos(i,2),pos(i,3),delta_v2(1)*100000,delta_v2(2)*100000,delta_v2(3)*100000)
% quiver3( pos(j,1),pos(j,2),pos(j,3),delta_v3(1)*100000,delta_v3(2)*100000,delta_v3(3)*100000)
hold off
grid on
for k = 1:1000:length(time)-999
    xvec = pos(k:k+999,1);
    yvec = pos(k:k+999,2);
    zvec = pos(k:k+999,3);
    addpoints(h,xvec,yvec,zvec)
    addpoints(shipWriter,xvec,yvec,zvec)
    lunarx = lunar_trajectory(k:k+100,1);
    lunary = lunar_trajectory(k:k+100,2);
    lunarz = lunar_trajectory(k:k+100,3);
    addpoints(moon_writer,lunarx,lunary,lunarz)
    drawnow

    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if k==1
        imwrite(imind,cm,'EarthCenter.gif','gif','Loopcount',inf);
    else
        imwrite(imind,cm,'EarthCenter.gif','gif','DelayTime',0,'WriteMode','append');
    end
end

% relative_position = pos-lunar_trajectory;
% figure(2)
% plot3(relative_position(:,1),relative_position(:,2),relative_position(:,3))
% xlim([-1,1]*10000);
% ylim([-1,1]*10000);p
% zlim([-1,1]*10000);


% Viewer
% figure(1)
% plot3(pos(:,1),pos(:,2),pos(:,3),'r')
% hold on
% surf( X_E , Y_E , Z_E , 'FaceColor' , [0,0.7,1] , 'EdgeColor' , [ 0 , 0.5 , 1 ] );
% plot3( lunar_pos(1),lunar_pos(2),lunar_pos(3),'Marker','o','MarkerFaceColor',[1,0.7,0])
% hold off
% grid on
% xlim([-3,0.4]*10^5); xlabel('x');
% ylim([-3,0.4]*10^5); ylabel('y');
% zlim([-3,0.4]*10^5); zlabel('z');
% 
% figure(2)
% plot3(pos(:,1)-lunar_pos(1),pos(:,2)-lunar_pos(2),pos(:,3)-lunar_pos(3),'r')
% hold on
% surf( X_M , Y_M , Z_M , 'FaceColor' , [1,0.7,0] , 'EdgeColor' , [ 1 , 0.5 , 0 ] );
% hold off
% xlim([-2000,2000])
% ylim([-2000,2000])
% zlim([-2000,2000])
% grid on