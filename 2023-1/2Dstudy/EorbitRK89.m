function [Trans_orb,min_distance] = EorbitRK89(y0,IConditions)

    mu_earth                    =   IConditions.Earth.mu;
    lunar_posATinj              =   IConditions.Lunar.posATinj';
    lunar_SOI                   =   IConditions.Lunar.SOI;
    dt                          =   IConditions.dt_rk89;

    i = 2;
    distance = sqrt(lunar_posATinj' * lunar_posATinj);
    min_distance = distance;

    pos = zeros(3,100000);
    vel = zeros(3,100000);
    % orb(:,1) = y0;
    pos(:,1) = y0(1:3)';
    vel(:,1) = y0(4:6)';
    r1 = y0(1:3)';
    v1 = y0(4:end)';


    while true
        % 1'st Order
        % r1 = y(1:3,i-1);
        % v1 = y(4:end,i-1);
        a1 = - mu_earth / sqrt( r1' * r1 ) ^ 3 * r1;

    
        % 2'nd Order
        r2 = r1+(4*dt/27)*v1;
        v2 = v1+(4*dt/27)*a1;
        a2 = - mu_earth / sqrt( r2' * r2 ) ^ 3 * r2;
    
        % 3'rd Order
        r3 = r1+(dt/18)*(v1+3*v2);
        v3 = v1+(dt/18)*(a1+3*a2);
        a3 = - mu_earth / sqrt( r3' * r3 ) ^ 3 * r3;

    
        % 4'th Order
        r4 = r1+(dt/12)*(v1+3*v3);
        v4 = v1+(dt/12)*(a1+3*a3);
        a4 = - mu_earth / sqrt( r4' * r4 ) ^ 3 * r4;

        % 5'th Order
        r5 = r1+(dt/8)*(v1+3*v4);
        v5 = v1+(dt/8)*(a1+3*a4);
        a5 = - mu_earth / sqrt( r5' * r5 ) ^ 3 * r5;

        % 6'th Order
        r6 = r1+(dt/54)*(13*v1-27*v3+42*v4+8*v5);
        v6 = v1+(dt/54)*(13*a1-27*a3+42*a4+8*a5);
        a6 = - mu_earth / sqrt( r6' * r6 ) ^ 3 * r6;

        % 7'th Order
        r7 = r1+(dt/4320)*(389*v1-54*v3+966*v4-824*v5+243*v6); 
        v7 = v1+(dt/4320)*(389*a1-54*a3+966*a4-824*a5+243*a6);
        a7 = - mu_earth / sqrt( r7' * r7 ) ^ 3 * r7;

        % 8'th Order
        r8 = r1+(dt/20)*(-231*v1+81*v3-1164*v4+656*v5-122*v6+800*v7);
        v8 = v1+(dt/20)*(-231*a1+81*a3-1164*a4+656*a5-122*a6+800*a7);
        a8 = - mu_earth / sqrt( r8' * r8 ) ^ 3 * r8;

        %9'th Order
        r9 = r1+(dt/288)*(-127*v1+18*v3-678*v4+456*v5-9*v6+576*v7+4*v8);
        v9 = v1+(dt/288)*(-127*a1+18*a3-678*a4+456*a5-9*a6+576*a7+4*a8);
        a9 = - mu_earth / sqrt( r9' * r9 ) ^ 3 * r9;

        % 10'th Order
        r10 = r1+(dt/820)*(1481*v1-81*v3+7104*v4-3376*v5+72*v6-5040*v7-60*v8+720*v9);
        v10 = v1+(dt/820)*(1481*a1-81*a3+7104*a4-3376*a5+72*a6-5040*a7-60*a8+720*a9);
        a10 = - mu_earth / sqrt( r10' * r10 ) ^ 3 * r10;

        % Next Value
        r1 = r1 + dt/840*(41*v1+27*v4+272*v5+27*v6+216*v7+216*v9+41*v10);
        v1 = v1 + dt/840*(41*a1+27*a4+272*a5+27*a6+216*a7+216*a9+41*a10);
        pos(:,i) = r1;
        vel(:,i) = v1;
        % orb(:,i) = [r1;v1];
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
                Trans_orb.orb = [pos(:,1:i-1);vel(:,1:i-1)];
                Trans_orb.T = (i-2)*dt;
                break;
            end

        i = i+1;
    end

end