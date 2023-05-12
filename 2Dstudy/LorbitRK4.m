function [y,min_distance,T,lunar_position,lunar_velocity] = LorbitRK4(dt,y0,lunar_posATinj)
    mu_lunar        =   4911.3;
    lunar_w         =   [0,0,2*pi / (27*24*3600)];
    y(:,1) = y0;
    i = 2;
    distance = norm(lunar_posATinj);
    min_distance = distance;
    lunar_position(:,1) = lunar_posATinj';
    lunar_velocity(:,1) = cross(lunar_w,lunar_posATinj)';
    while true

        r1 = y(1:3,i-1)-lunar_position(:,i-1);
        v1 = y(4:6,i-1)+lunar_velocity(:,i-1);
        a1 = - mu_lunar / sum ( r1.^2 )^(1.5) * r1;
        k1 = dt*[v1;a1];
    
        r2 = r1+0.5*k1(1:3);
        v2 = v1+0.5*k1(4:6);
        a2 = - mu_lunar / sum ( r2.^2 )^(1.5) * r2;
        k2 = dt*[v2;a2];
    
        r3 = r1+0.5*k2(1:3);
        v3 = v1+0.5*k2(4:6);
        a3 = - mu_lunar / sum ( r3.^2 )^(1.5) * r3;
        k3 = dt*[v3;a3];
    
        r4 = r1+k3(1:3);
        v4 = v1+k3(4:6);
        a4 = - mu_lunar / sum ( r4.^2 )^(1.5) * r4;
        k4 = dt*[v4;a4];
        y(:,i) = y(:,i-1) + (k1+2*k2+2*k3+k4)/6;
        lunar_position(:,i) = lunar_position(:,i-1) + lunar_velocity(:,i-1)*dt';
        lunar_velocity(:,i) = cross(lunar_w,lunar_position(:,i))';

        pre_distance = distance;
        distance = norm(lunar_position(:,i)-y(1:3,i));
        
        if distance < min_distance
            min_distance = distance;
        end

%         if distance > 100
        if i > 24*3600*1
            y = y(:,1:end-1);
            lunar_position = lunar_position(:,1:end-1);
            lunar_velocity = lunar_velocity(:,1:end-1);
            T = (i-2)*5;
            break;
        end
        i = i+1;
        
    end
end