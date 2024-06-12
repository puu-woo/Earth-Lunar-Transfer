zero  = [0,0,0];
x_eci = [1,0,0];
y_eci = [0,1,0];
z_eci = [0,0,1];

view(3)
hold on
pv(x_eci,'r')
pv(y_eci,'g')
pv(z_eci,'b')
hold off

function pv(vector,c)
    quiver3(0,0,0,vector(1),vector(2),vector(3),'ShowArrowHead','off','Color',c);
end