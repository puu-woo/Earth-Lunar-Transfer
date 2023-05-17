function [y,min_distance,T,lunar_position,lunar_velocity] = LorbitRK4(dt,y0,lunar_posATinj)
    mu_lunar        =   4911.3;
    mu_earth        =   398600;
    lunar_w         =   [0,0,2*pi / (27*24*3600)];
    y(:,1) = y0;
    i = 2;
    distance = customNorm(lunar_posATinj);
    min_distance = distance;
    lunar_position(:,1) = lunar_posATinj';
    lunar_velocity(:,1) = customCross(lunar_w,lunar_posATinj)';
    while true
        
        lp = lunar_position(:,i-1);

        % 1'st Order
        r1e = y(1:3,i-1);
        r1l = r1e-lp;
        v1 = y(4:6,i-1);
        a1 = - mu_lunar / customNorm( r1l )^3 * r1l - mu_earth / customNorm( r1e )^3 * r1e;
        k1 = dt*[v1;a1];
        
        % 2'nd Order
        r2e = r1e+0.5*k1(1:3);
        r2l = r2e-lp;
        v2 = v1+0.5*k1(4:6);
        a2 = - mu_lunar / customNorm( r2l )^3 * r2l - mu_earth / customNorm( r2e )^3 * r2e;
        k2 = dt*[v2;a2];
    
        % 3'rd Order
        r3e = r1e+0.5*k2(1:3);
        r3l = r3e-lp;
        v3 = v1+0.5*k2(4:6);
        a3 = - mu_lunar / customNorm( r3l )^3 * r3l - mu_earth / customNorm( r3e )^3 * r3e;
        k3 = dt*[v3;a3];
    
        % 4'th Order
        r4e = r1e+k3(1:3);
        r4l = r4e-lp;
        v4 = v1+k3(4:6);
        a4 = - mu_lunar / customNorm( r4l )^3* r4l  - mu_earth / customNorm( r4e )^3 * r4e;
        k4 = dt*[v4;a4];

        % Sum Orders
        y(:,i) = y(:,i-1) + (k1+2*k2+2*k3+k4)/6;
        %End RK4

        % Lunar
        lunar_position(:,i) = lp + lunar_velocity(:,i-1)*dt';
        lunar_velocity(:,i) = customCross(lunar_w,lp)';

        % Minimize distance algorithm
        pre_distance = distance;
        distance = customNorm(lunar_position(:,i)-y(1:3,i));
        
        if distance < min_distance
            min_distance = distance;
        end

%         if distance > 100
        if i > 24*3600*1
            y = y(:,1:end-1);
            lunar_position = lunar_position(:,1:end-1);
            lunar_velocity = lunar_velocity(:,1:end-1);
            T = (i-2)*dt;
            break;
        end
        i = i+1;
        
    end
end