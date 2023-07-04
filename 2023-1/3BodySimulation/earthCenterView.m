myVideo = VideoWriter("ttt");
myVideo.FrameRate = 40;
myVideo.Quality = 99;
open(myVideo);

h = animatedline('Color','r');
shipWriter = animatedline('Color','r','Marker',".",'LineWidth',5,'MarkerFaceColor','r','MaximumNumPoints',100);
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',10,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',10);

fig = figure(1);
i = round(T_trans / dt);
j = round((T_trans + T_injec) / dt );
view([0 10])
title('Earth Centered View (Unit : km)')
xlim([-4.5,4.5]*10^5); xlabel('x');
ylim([-4.5,4.5]*10^5); ylabel('y');
zlim([-4,4]*10^5); zlabel('z');
hold on
p_earth = plot3( 0,0,0,'Marker','o','MarkerFaceColor',[0,0.7,1]);
p_lunar = surf( X_M , Y_M , Z_M , 'FaceColor' , [1,0.7,0] , 'EdgeColor' , [ 1 , 0.5 , 0 ] );
p_lunar2 = plot3( lunar_orb(1,:),lunar_orb(2,:),lunar_orb(3,:),'Color',[1,0.8,0]);
% quiver3( pos(i,1),pos(i,2),pos(i,3),delta_v2(1)*100000,delta_v2(2)*100000,delta_v2(3)*100000)
% quiver3( pos(j,1),pos(j,2),pos(j,3),delta_v3(1)*100000,delta_v3(2)*100000,delta_v3(3)*100000)
hold off
grid on
legend([h,p_lunar,p_earth,p_lunar2],'Transfer Orbit','Lunar','Earth','Lunar Orbit','Location','best');
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
%     writeVideo(myVideo,frame)
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if k==1
        imwrite(imind,cm,'EarthCenter.gif','gif','Loopcount',inf);
    else
        imwrite(imind,cm,'EarthCenter.gif','gif','DelayTime',0,'WriteMode','append');
    end
end
% close(myVideo)