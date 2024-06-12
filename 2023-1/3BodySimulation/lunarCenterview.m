h = animatedline('Color','r');
shipWriter = animatedline('Color','r','Marker',".",'MarkerSize',12,'MarkerFaceColor','r','MaximumNumPoints',100);
earth_writer = animatedline('Color',[0,0.5,1],'Marker',".",'MarkerSize',20,'MarkerFaceColor',[0,0.7,1],'MaximumNumPoints',10);


X_M2                 =   X * 1700;
Y_M2                 =   Y * 1700;
Z_M2                 =   Z * 1700;

i = round(T_trans / dt);
j = round((T_trans + T_injec) / dt );
view([5 15])
title('Lunar Centered View (Unit : km)')
xlim([-4,4.5]*10^5); xlabel('x');
ylim([-4,4.5]*10^5); ylabel('y');
zlim([-4,3]*10^5); zlabel('z');
hold on
plot3( 0,0,0,'Marker','o','Color',[1,0.5,0],'MarkerFaceColor',[1,0.7,0])
p_lunar = surf( X_M2 , Y_M2 , Z_M2 , 'FaceColor' , [1,0.7,0] , 'EdgeColor' , [ 1 , 0.5 , 0 ] );
plot3(-lunar_trajectory(:,1),-lunar_trajectory(:,2),-lunar_trajectory(:,3),'Color',[0.1,0.7,1])
hold off
grid on
legend([h,earth_writer,p_lunar],'Transfer Orbit','Earth Orbit','Lunar','Location','best')
for k = 1:1000:length(time)-999
    lunarx = lunar_trajectory(k:k+999,1);
    lunary = lunar_trajectory(k:k+999,2);
    lunarz = lunar_trajectory(k:k+999,3);
    xvec = pos(k:k+999,1)-lunarx;
    yvec = pos(k:k+999,2)-lunary;
    zvec = pos(k:k+999,3)-lunarz;
    addpoints(h,xvec,yvec,zvec)
    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(earth_writer,-lunarx,-lunary,-lunarz)
    drawnow

    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if k==1
        imwrite(imind,cm,'LunarCenter.gif','gif','Loopcount',inf);
    else
        imwrite(imind,cm,'LunarCenter.gif','gif','DelayTime',0,'WriteMode','append');
    end
end
% relative_position = pos-lunar_trajectory;
% figure(2)
% 
% plot3(relative_position(:,1),relative_position(:,2),relative_position(:,3))
% 
% xlim([-5,5]*100000);
% ylim([-5,5]*100000);
% zlim([-5,5]*100000);
% grid on
% xlabel('x');
% ylabel('y');
% zlabel('z');