% Lunar Orbit


% Sub Plot 2
theta = linspace(0,2*pi,1000);
lxx = (R_lunar+Rmission)*cos(theta);
lyy = (R_lunar+Rmission)*sin(theta);

yy = orb(1:3,:)-lunar_pos';
for i = 1:length(yy)
    yvv(:,i) = orb(4:6,i)-lunar_vel(i,:)';
end

subplot(2,2,2)
plot(yy(1,:),yy(2,:))
title('ME ( MJ2000 )')
hold on
plot(lxx,lyy,'--')
hold off
xlim([-7,1]*10^4)
ylim([-1,1]*10^4)
grid on

% Sub Plot3
subplot(2,2,3)
plot(yvv(1,:),yvv(2,:))
grid on

% Sub Plot 1
sub2 = subplot(2,2,1);
title('J2000')
shipWriter = animatedline('Color','r','Marker',".",'LineWidth',5,'MarkerFaceColor','r','MaximumNumPoints',100);
moon_writer = animatedline('Color',[1,0.4,0],'Marker',".",'MarkerSize',10,'MarkerFaceColor',[1,0.4,0],'MaximumNumPoints',10);


hold on
plot(lunar_pos(:,1),lunar_pos(:,2))
plot(orb(1,:),orb(2,:))
plot(E_x,E_y,'--')
plot(L_x,L_y,'--')
plot(L_SOI_x,L_SOI_y,'--')
hold off
xlim([-1,5]*10^5);
ylim([-1,4]*10^5);
grid on


for k = 1:100:length(orb)-99
    xvec = orb(1,k:k+99);
    yvec = orb(2,k:k+99);
    zvec = orb(3,k:k+99);

    lunarx = lunar_pos(k:k+99,1);
    lunary = lunar_pos(k:k+99,2);
    lunarz = lunar_pos(k:k+99,3);

    addpoints(shipWriter,xvec,yvec,zvec)
    addpoints(moon_writer,lunarx,lunary,lunarz)
    drawnow
end


