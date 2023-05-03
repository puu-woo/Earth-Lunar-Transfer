function y = MorbitRK4(stopstep,dt,y0,lunar_pos)
    mu_lunar                    =   4911.3;
    y(:,1) = y0;
    for i = 2:stopstep+1
        r1 = y(1:3,i-1)-lunar_pos(:,i-1);
        v1 = y(4:6,i-1);
        a1 = - mu_lunar / sum ( r1.^2 )^(1.5) * r1;
        k1 = dt*[v1;a1];
    
        r2 = y(1:3,i-1)-lunar_pos(:,i-1)+0.5*k1(1:3);
        v2 = y(4:6,i-1)+0.5*k1(4:6);
        a2 = - mu_lunar / sum ( r2.^2 )^(1.5) * r2;
        k2 = dt*[v2;a2];
    
        r3 = y(1:3,i-1)-lunar_pos(:,i-1)+0.5*k2(1:3);
        v3 = y(4:6,i-1)+0.5*k2(4:6);
        a3 = - mu_lunar / sum ( r3.^2 )^(1.5) * r3;
        k3 = dt*[v3;a3];
    
        r4 = y(1:3,i-1)-lunar_pos(:,i-1)+k3(1:3);
        v4 = y(4:6,i-1)+k3(4:6);
        a4 = - mu_lunar / sum ( r4.^2 )^(1.5) * r4;
        k4 = dt*[v4;a4];
    
        y(:,i) = y(:,i-1) + (k1+2*k2+2*k3+k4)/6;
    end
end