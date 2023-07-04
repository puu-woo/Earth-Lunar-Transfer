%% Revision history
%   - 2023/04/24, by 동민
%=========================================================================

[X,Y,Z] = sphere;
X_M                 =   X * LunarRadius+lunar_posAtarrival(1,1);
Y_M                 =   Y * LunarRadius+lunar_posAtarrival(1,2);
Z_M                 =   Z * LunarRadius+lunar_posAtarrival(1,3);

X_M2                 =   X * LunarRadius;
Y_M2                 =   Y * LunarRadius;
Z_M2                 =   Z * LunarRadius;

figure(1)
p_sat = plot3(posj2000(:,1),posj2000(:,2),posj2000(:,3),'r');
grid on
hold on
p_earth = surf( X_M , Y_M , Z_M , 'FaceColor' , [1,0.7,0] , 'EdgeColor' , [ 1 , 0.5 , 0 ] );
p_lunar = surf( X_M , Y_M , Z_M , 'FaceColor' , [1,0.7,0] , 'EdgeColor' , [ 1 , 0.5 , 0 ] );
title('Earth Centered View Case 2 (unit : km)')
legend([p_sat,p_lunar],'trajectory','Lunar','Location','best');
% xlim([-4,4]*10^5);
% ylim([-4,4]*10^5);
% zlim([-4,4]*10^5);
xlabel('x');
ylabel('y');
zlabel('z');

figure(2)
p_sat2 = plot3(posME(:,1),posME(:,2),posME(:,3),'r');
hold on
p_lunar2 = surf( X_M2 , Y_M2 , Z_M2 , 'FaceColor' , [1,0.7,0] , 'EdgeColor' , [ 1 , 0.5 , 0 ] );
hold off
title('Lunar Centered View Case 2 (unit : km)')
legend([p_sat2,p_lunar2],'trajectory','Lunar','Location','best');
% xlim([-2,2]*10^3);
% ylim([-2,2]*10^3);
% zlim([-2,2]*10^3);
xlabel('x');
ylabel('y');
zlabel('z');
grid on