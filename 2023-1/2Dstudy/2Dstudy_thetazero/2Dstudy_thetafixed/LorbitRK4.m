function [LOI_orb,Lunar_orb,min_distance] = LorbitRK4(v0,y0,IConditions,lunar_initPos,mode)

    mu_earth        =   IConditions.Earth.mu;
    mu_lunar        =   IConditions.Lunar.mu;
    dt              =   IConditions.dt;
    lunar_w         =   [0,0,2*pi / (27*24*3600)];

    i = 2;
    distance       = norm(lunar_initPos);
    min_distance   = distance;
    lunar_pos(:,1) = lunar_initPos;
    lunar_vel(:,1) = cross(lunar_w,lunar_initPos')';


    pos         = zeros(3,100000);
    vel         = zeros(3,100000);
    pos(:,1)    = y0(1:3);
    vel(:,1)    = v0;
    lp          = lunar_pos(:,1);
    r1e         = pos(:,1);
    r1l         = r1e-lp;
    v1          = vel(:,1);

    while true
        
        % lp = lunar_position(:,i-1);

        % 1'st Order
        % r1e = y(1:3,i-1);
        % r1l = r1e-lp;
        % v1 = y(4:6,i-1);
        a1 = - mu_lunar / sqrt( r1l' * r1l ) ^ 3 * r1l - mu_earth / sqrt( r1e' * r1e ) ^ 3 * r1e;
        % k1 = dt*[v1;a1];
        
        % 2'nd Order
        r2e = r1e+0.5*v1*dt;
        r2l = r2e-lp;
        v2  = v1+0.5*a1*dt;
        a2  = - mu_lunar / sqrt( r2l' * r2l )^3 * r2l - mu_earth / sqrt( r2e' * r2e )^3 * r2e;
        % k2 = dt*[v2;a2];
    
        % 3'rd Order
        r3e = r1e+0.5*v2*dt;
        r3l = r3e-lp;
        v3  = v1+0.5*a2*dt;
        a3  = - mu_lunar / sqrt( r3l' * r3l )^3 * r3l - mu_earth / sqrt( r3e' * r3e )^3 * r3e;
        % k3 = dt*[v3;a3];
    
        % 4'th Order
        r4e = r1e+v3*dt;
        r4l = r4e-lp;
        v4  = v1+a3*dt;
        a4  = - mu_lunar / sqrt( r4l' * r4l )^3* r4l  - mu_earth / sqrt( r4e' * r4e )^3 * r4e;
        % k4 = dt*[v4;a4];


        % Lunar Update
        lp = lp + lunar_vel(:,i-1)*dt';
        lunar_pos(:,i) = lp;
        lunar_vel(:,i) = cross(lunar_w,lp)';

        % Sum Orders
        
        % 1'st Order Update
        r1e = (2*r2e + 4*r3e + (2*v3 + v4)*dt)/6;
        r1l = r1e - lp;
        v1 = (2*v2 + 4*v3 + (2*a3 + a4)*dt)/6;
        pos(:,i) = r1e;
        vel(:,i) = v1;
        % y(:,i) = [kk ; 2*v2 + 4*v3 + (2*a3 + a4)*dt]/6;
        % y(:,i) = y(:,i-1) + [v1+2*v2+2*v3+v4;a1+2*a2+2*a3+a4]*dt/6;
        % y(:,i) = y(:,i-1) + (k1+2*k2+2*k3+k4)/6;
        %End RK4

        % Minimize distance algorithm
        pre_distance = distance;

        vectorfromLunar = lunar_pos(:,i)-r1e;
        % vectorfromLunar = lunar_position(:,i)-y(1:3,i);
        distance = sqrt(vectorfromLunar' * vectorfromLunar);
        
        if distance < min_distance
            min_distance = distance;
        end

        if mode == "LOI"
            if distance > pre_distance
                LOI_orb.orb  =  [pos(:,1:i-1);vel(:,1:i-1)];
                Lunar_orb.pos = lunar_pos(:,1:i-1);
                Lunar_orb.vel = lunar_vel(:,1:i-1);
                LOI_orb.T = (i-2)*dt;
                break;
            end
        elseif mode=="draft"
            if i > 24*3600*0.5
                LOI_orb.orb  =  [pos(:,1:i-1);vel(:,1:i-1)];
                Lunar_orb.pos = lunar_pos(:,1:i-1);
                Lunar_orb.vel = lunar_vel(:,1:i-1);
                LOI_orb.T = (i-2)*dt;
                break;
            end
        end
        i = i+1;
        
    end
end