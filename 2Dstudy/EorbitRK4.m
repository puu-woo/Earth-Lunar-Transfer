function [y,min_distance,T] = EorbitRK4(dt,y0,lunar_posATinj,lunar_SOI)
    mu_earth                    =   398600;
    y(:,1) = y0;
    i = 2;
    distance = customNorm(lunar_posATinj);
    min_distance = distance;

    while true
        % 1'st Order
        r1 = y(1:3,i-1);
        v1 = y(4:6,i-1);
        a1 = - mu_earth / customNorm( r1 ) ^ 3 * r1;
        k1 = dt*[v1;a1];
    
        % 2'nd Order
        r2 = r1+0.5*k1(1:3);
        v2 = v1+0.5*k1(4:6);
        a2 = - mu_earth / customNorm( r2 ) ^ 3 * r2;
        k2 = dt*[v2;a2];
    
        % 3'rd Order
        r3 = r1+0.5*k2(1:3);
        v3 = v1+0.5*k2(4:6);
        a3 = - mu_earth / customNorm( r3 ) ^ 3 * r3;
        k3 = dt*[v3;a3];
    
        % 4'th Order
        r4 = r1+k3(1:3);
        v4 = v1+k3(4:6);
        a4 = - mu_earth / customNorm( r4 )^3 * r4;
        k4 = dt*[v4;a4];
    
        % Sum Orders
        y(:,i) = y(:,i-1) + (k1 + 2*k2 + 2*k3 + k4) / 6;
        % End RK4

        pre_distance = distance;
        distance = customNorm(lunar_posATinj'-y(1:3,i))-lunar_SOI; 

            if distance < min_distance
                min_distance = distance;
            end
    
            if distance > pre_distance
                y = y(:,1:end-1);
                T = (i-2)*5;
                break;
            end

        i = i+1;
    end
end