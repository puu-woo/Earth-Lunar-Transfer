function [Trans_orb,Lunar_orb,min_distance] = orbitRK89(y0,IConditions,Lunar_pos_init)

    mu_earth                    =   IConditions.Earth.mu;
    mu_lunar                    =   IConditions.Lunar.mu;
    %lunar_SOI                   =   IConditions.Lunar.SOI;
    dt                          =   IConditions.dt_rk89;
    lunar_w                     =   IConditions.Lunar.w;
    h_mission                   =   IConditions.Lunar.h_mission;

    lunar_pos(:,1) = Lunar_pos_init;
    lunar_vel(:,1) = cross(lunar_w,Lunar_pos_init)';

    i = 2;
    distance = 10^6;
    min_distance = distance;

    pos = zeros(3,200000);
    vel = zeros(3,200000);

    pos(:,1) = y0(1:3,1);
    vel(:,1) = y0(4:6,1);
    r1 = y0(1:3,1);
    v1 = y0(4:end,1);


    lp = lunar_pos(:,1);
    r1l         = r1-lp;
    
    w = norm(lunar_w);
    lunar_rot2 = w*dt/27;
    lunar_rot3 = w*dt/18;
    lunar_rot4 = w*dt/12;
    lunar_rot5 = w*dt/8;
    lunar_rot6 = w*dt/54;
    lunar_rot7 = w*dt/4320;
    lunar_rot8 = w*dt/20;
    lunar_rot9 = w*dt/288;
    lunar_rot10 = w*dt/820;


    dcm_lunar_rot2 = [cos(lunar_rot2), sin(lunar_rot2), 0 ;...
                     -sin(lunar_rot2), cos(lunar_rot2), 0; ...
                     0 , 0 , 1];
    lp2 = dcm_lunar_rot2'*lp;

    dcm_lunar_rot3 = [cos(lunar_rot3), sin(lunar_rot3), 0 ;...
                     -sin(lunar_rot3), cos(lunar_rot3), 0; ...
                     0 , 0 , 1];
    lp3 = dcm_lunar_rot3'*lp;

    dcm_lunar_rot4 = [cos(lunar_rot4), sin(lunar_rot4), 0 ;...
                     -sin(lunar_rot4), cos(lunar_rot4), 0; ...
                     0 , 0 , 1];
    lp4 = dcm_lunar_rot4'*lp;

    dcm_lunar_rot5 = [cos(lunar_rot5), sin(lunar_rot5), 0 ;...
                     -sin(lunar_rot5), cos(lunar_rot5), 0; ...
                     0 , 0 , 1];
    lp5 = dcm_lunar_rot5'*lp;

    dcm_lunar_rot6 = [cos(lunar_rot6), sin(lunar_rot6), 0 ;...
                     -sin(lunar_rot6), cos(lunar_rot6), 0; ...
                     0 , 0 , 1];
    lp6 = dcm_lunar_rot6'*lp;

    dcm_lunar_rot7 = [cos(lunar_rot7), sin(lunar_rot7), 0 ;...
                     -sin(lunar_rot7), cos(lunar_rot7), 0; ...
                     0 , 0 , 1];
    lp7 = dcm_lunar_rot7'*lp;

    dcm_lunar_rot8 = [cos(lunar_rot8), sin(lunar_rot8), 0 ;...
                     -sin(lunar_rot8), cos(lunar_rot8), 0; ...
                     0 , 0 , 1];
    lp8 = dcm_lunar_rot8'*lp;

    dcm_lunar_rot9 = [cos(lunar_rot9), sin(lunar_rot9), 0 ;...
                     -sin(lunar_rot9), cos(lunar_rot9), 0; ...
                     0 , 0 , 1];
    lp9 = dcm_lunar_rot9'*lp;

    dcm_lunar_rot10 = [cos(lunar_rot10), sin(lunar_rot10), 0 ;...
                      -sin(lunar_rot10), cos(lunar_rot10), 0; ...
                      0 , 0 , 1];
    lp10 = dcm_lunar_rot10'*lp;

    lunar_rot = w*dt;
    dcm_lunar_rot = [cos(lunar_rot), sin(lunar_rot), 0 ;...
                     -sin(lunar_rot), cos(lunar_rot), 0; ...
                     0 , 0 , 1];

    while true
        
        % 1'st Order
        % r1 = y(1:3,i-1);
        % v1 = y(4:end,i-1);

        a1 = - mu_earth / sqrt( r1' * r1 ) ^ 3 * r1 - mu_lunar / sqrt( r1l' * r1l ) ^ 3 * r1l - mu_lunar / sqrt( lp' * lp ) ^ 3 * lp;

        % 2'nd Order
        r2 = r1+(4*dt/27)*v1;
        r2l = r2-lp2;
        v2 = v1+(4*dt/27)*a1;
        a2 = - mu_earth / sqrt( r2' * r2 ) ^ 3 * r2 - mu_lunar / sqrt( r2l' * r2l ) ^ 3 * r2l - mu_lunar / sqrt( lp2' * lp2 ) ^ 3 * lp2;
    
        % 3'rd Order
        r3 = r1+(dt/18)*(v1+3*v2);
        r3l = r3-lp3;
        v3 = v1+(dt/18)*(a1+3*a2);
        a3 = - mu_earth / sqrt( r3' * r3 ) ^ 3 * r3 - mu_lunar / sqrt( r3l' * r3l ) ^ 3 * r3l - mu_lunar / sqrt( lp3' * lp3 ) ^ 3 * lp3;

    
        % 4'th Order
        r4 = r1+(dt/12)*(v1+3*v3);
        r4l = r4-lp4;
        v4 = v1+(dt/12)*(a1+3*a3);
        a4 = - mu_earth / sqrt( r4' * r4 ) ^ 3 * r4 - mu_lunar / sqrt( r4l' * r4l ) ^ 3 * r4l - mu_lunar / sqrt( lp4' * lp4 ) ^ 3 * lp4;

        % 5'th Order
        r5 = r1+(dt/8)*(v1+3*v4);
        r5l = r5-lp5;
        v5 = v1+(dt/8)*(a1+3*a4);
        a5 = - mu_earth / sqrt( r5' * r5 ) ^ 3 * r5 - mu_lunar / sqrt( r5l' * r5l ) ^ 3 * r5l - mu_lunar / sqrt( lp5' * lp5 ) ^ 3 * lp5;

        % 6'th Order
        r6 = r1+(dt/54)*(13*v1-27*v3+42*v4+8*v5);
        r6l = r6-lp6;
        v6 = v1+(dt/54)*(13*a1-27*a3+42*a4+8*a5);
        a6 = - mu_earth / sqrt( r6' * r6 ) ^ 3 * r6 - mu_lunar / sqrt( r6l' * r6l ) ^ 3 * r6l - mu_lunar / sqrt( lp6' * lp6 ) ^ 3 * lp6;

        % 7'th Order
        r7 = r1+(dt/4320)*(389*v1-54*v3+966*v4-824*v5+243*v6); 
        r7l = r7-lp7;
        v7 = v1+(dt/4320)*(389*a1-54*a3+966*a4-824*a5+243*a6);
        a7 = - mu_earth / sqrt( r7' * r7 ) ^ 3 * r7 - mu_lunar / sqrt( r7l' * r7l ) ^ 3 * r7l - mu_lunar / sqrt( lp7' * lp7 ) ^ 3 * lp7;

        % 8'th Order
        r8 = r1+(dt/20)*(-231*v1+81*v3-1164*v4+656*v5-122*v6+800*v7);
        r8l = r8-lp8;
        v8 = v1+(dt/20)*(-231*a1+81*a3-1164*a4+656*a5-122*a6+800*a7);
        a8 = - mu_earth / sqrt( r8' * r8 ) ^ 3 * r8 - mu_lunar / sqrt( r8l' * r8l ) ^ 3 * r8l - mu_lunar / sqrt( lp8' * lp8 ) ^ 3 * lp8;

        %9'th Order
        r9 = r1+(dt/288)*(-127*v1+18*v3-678*v4+456*v5-9*v6+576*v7+4*v8);
        r9l = r9-lp9;
        v9 = v1+(dt/288)*(-127*a1+18*a3-678*a4+456*a5-9*a6+576*a7+4*a8);
        a9 = - mu_earth / sqrt( r9' * r9 ) ^ 3 * r9 - mu_lunar / sqrt( r9l' * r9l ) ^ 3 * r9l - mu_lunar / sqrt( lp9' * lp9 ) ^ 3 * lp9;

        % 10'th Order
        r10 = r1+(dt/820)*(1481*v1-81*v3+7104*v4-3376*v5+72*v6-5040*v7-60*v8+720*v9);
        r10l = r10-lp10;
        v10 = v1+(dt/820)*(1481*a1-81*a3+7104*a4-3376*a5+72*a6-5040*a7-60*a8+720*a9);
        a10 = - mu_earth / sqrt( r10' * r10 ) ^ 3 * r10 - mu_lunar / sqrt( r10l' * r10l ) ^ 3 * r10l - mu_lunar / sqrt( lp10' * lp10 ) ^ 3 * lp10;

        lp = dcm_lunar_rot'*lp;
        lp2 = dcm_lunar_rot2'*lp;
        lp3 = dcm_lunar_rot3'*lp;
        lp4 = dcm_lunar_rot4'*lp;
        lp5 = dcm_lunar_rot5'*lp;
        lp6 = dcm_lunar_rot6'*lp;
        lp7 = dcm_lunar_rot7'*lp;
        lp8 = dcm_lunar_rot8'*lp;
        lp9 = dcm_lunar_rot9'*lp;
        lp10 = dcm_lunar_rot10'*lp;

        lunar_pos(:,i) = lp;
        lunar_vel(:,i) = cross(lunar_w,lp)';


        % Next Value
        r1 = r1 + dt/840*(41*v1+27*v4+272*v5+27*v6+216*v7+216*v9+41*v10);
        r1l = r1-lp;
        v1 = v1 + dt/840*(41*a1+27*a4+272*a5+27*a6+216*a7+216*a9+41*a10);
        pos(:,i) = r1;
        vel(:,i) = v1;
        % orb(:,i) = [r1;v1];
        % y(:,i) = [kk ; 2*v2 + 4*v3 + (2*a3 + a4)*dt]/6;
        % y(:,i) = y(:,i-1) + [v1+2*v2+2*v3+v4;a1+2*a2+2*a3+a4]*dt/6;
        % y(:,i) = y(:,i-1) + (k1 + 2*k2 + 2*k3 + k4) / 6;
        % End RK4

        pre_distance = distance;

        vectorfromLunar = lp-r1;
        distance = sqrt(vectorfromLunar' * vectorfromLunar)-h_mission;

        if distance < min_distance
            min_distance = distance;
        end

        if (i-2)*dt > 24*3600*0.1 && distance > pre_distance
            min_distance = abs(min_distance);
            Trans_orb.orb = [pos(:,1:i-1);vel(:,1:i-1)];
            Trans_orb.T = (i-2)*dt;
            Lunar_orb.orb = [lunar_pos(:,1:i-1);lunar_vel(:,1:i-1)];
            break;
        end

        i = i+1;
    end

end