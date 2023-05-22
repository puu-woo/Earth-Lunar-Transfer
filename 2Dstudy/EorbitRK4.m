function [Trans_orb,min_distance] = EorbitRK4(y0,IConditions)

    mu_earth                    =   IConditions.Earth.mu;
    lunar_posATinj              =   IConditions.Lunar.posATinj';
    lunar_SOI                   =   IConditions.Lunar.SOI;
    dt                          =   IConditions.dt;

    i = 2;
    distance = sqrt(lunar_posATinj' * lunar_posATinj);
    min_distance = distance;

    orb = zeros(6,100000);
    orb(:,1) = y0;
    r1 = y0(1:3)';
    v1 = y0(4:end)';

    while true
        % 1'st Order
        % r1 = y(1:3,i-1);
        % v1 = y(4:end,i-1);
        a1 = - mu_earth / sqrt( r1' * r1 ) ^ 3 * r1;
        % k1 = dt*[v1;a1];
    
        % 2'nd Order
        r2 = r1+0.5*v1*dt;
        v2 = v1+0.5*a1*dt;
        a2 = - mu_earth / sqrt( r2' * r2 ) ^ 3 * r2;
        % k2 = dt*[v2;a2];
    
        % 3'rd Order
        r3 = r1+0.5*v2*dt;
        v3 = v1+0.5*a2*dt;
        a3 = - mu_earth / sqrt( r3' * r3 ) ^ 3 * r3;
        % k3 = dt*[v3;a3];
    
        % 4'th Order
        r4 = r1+v3*dt;
        v4 = v1+a3*dt;
        a4 = - mu_earth / sqrt( r4' * r4 ) ^ 3 * r4;
        % k4 = dt*[v4;a4];
    
        % Sum Orders
        r1 = (2*r2 + 4*r3 + (2*v3 + v4)*dt)/6;
        v1 = (2*v2 + 4*v3 + (2*a3 + a4)*dt)/6;
        orb(:,i) = [r1;v1];
        % y(:,i) = [kk ; 2*v2 + 4*v3 + (2*a3 + a4)*dt]/6;
        % y(:,i) = y(:,i-1) + [v1+2*v2+2*v3+v4;a1+2*a2+2*a3+a4]*dt/6;
        % y(:,i) = y(:,i-1) + (k1 + 2*k2 + 2*k3 + k4) / 6;
        % End RK4

        pre_distance = distance;

        vectorfromLunar = lunar_posATinj-r1;
        distance = sqrt(vectorfromLunar' * vectorfromLunar)-lunar_SOI; 

            if distance < min_distance
                min_distance = distance;
            end
    
            if distance > pre_distance
                Trans_orb.orb = orb(:,1:i-1);
                Trans_orb.T = (i-2)*dt;
                break;
            end

        i = i+1;
    end

end