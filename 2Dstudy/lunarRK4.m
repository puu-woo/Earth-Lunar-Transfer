function y = lunarRK4(stopstep,dt,y0)
lunar_w         =   [0,0,2*pi / (27*24*3600)];
y(1,:) = y0;
    for i = 2:stopstep+1
        r1 = y(i-1,:);
        dr1 = cross(lunar_w,r1);
        k1 = dt*dr1;

        r2 = y(i-1,:)+0.5*k1;
        dr2 = cross(lunar_w,r2);
        k2 = dt*dr2;

        r3 = y(i-1,:)+0.5*k2;
        dr3 = cross(lunar_w,r3);
        k3 = dt*dr3;

        r4 = y(i-1,:)+k3;
        dr4 = cross(lunar_w,r4);
        k4 = dt*dr4;

        y(i,:) = y(i-1,:)+(k1+2*k2+2*k3+k4)/6;


    end


end