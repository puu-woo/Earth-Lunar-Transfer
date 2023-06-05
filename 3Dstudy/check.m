oev = mission_orb.oev;
sorb = mission_orb.orb;
lorb = Lunar_orb_mission.orb;
orb = sorb - lorb;


a = oev(1);
e = oev(2);
inc = oev(3);
argper = oev(4);
raan = oev(5);
f = oev(6);


nu = linspace(f,f+2*pi,1000);
r = a*(1-e^2) ./ (1+e*cos(nu));


rx = r.*cos(nu);
ry = r.*sin(nu);
rz = 0.*sin(nu);


dcm = DCMeci2pq(argper+f,inc,raan);
y = dcm'*[rx;ry;rz];


view(3)
figure(1)
plot3(y(1,:),y(2,:),y(3,:))
hold on
plot3(orb(1,:),orb(2,:),orb(3,:))
hold off