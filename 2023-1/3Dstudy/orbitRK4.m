function [mission_orb,Lunar_orb] = orbitRK4(y0,IConditions,earth_initPos)

    mu_earth        =   IConditions.Earth.mu;
    mu_lunar        =   IConditions.Lunar.mu;
    earth_w         =   IConditions.Lunar.w;
    dt              =   IConditions.dt_rk4;

    earth_pos   = zeros(3,100000);
    earth_vel   = zeros(3,100000);
    pos         = zeros(3,100000);
    vel         = zeros(3,100000);
    g_earth     = zeros(3,100000);
    g_lunar     = zeros(3,100000);


    earth_pos(:,1) = earth_initPos;
    earth_vel(:,1) = cross(earth_w,earth_initPos')';
    pos(:,1)    = y0(1:3);
    vel(:,1)    = y0(4:6);


    ep1          = earth_pos(:,1);
    ev1          = earth_vel(:,1);
    ea1          = (-mu_lunar - mu_earth ) / sqrt( ep1' * ep1 ) ^ 3 * ep1;

    r1         = pos(:,1);
    r1e         = r1-ep1;
    v1          = vel(:,1);
    a_earth     = - mu_earth / sqrt( r1e' * r1e ) ^ 3 * r1e;
    a_lunar     = - mu_lunar / sqrt( r1' * r1 ) ^ 3 * r1;
    a1 = a_lunar + a_earth - mu_earth / sqrt( ep1' * ep1 ) ^ 3 * ep1;

    g_earth(:,1) = a_earth;
    g_lunar(:,1) = a_lunar;

    i = 2;
    while true
        
        % lp = lunar_position(:,i-1);

        % 1'st Order
        % r1e = y(1:3,i-1);
        % r1l = r1e-lp;
        % v1 = y(4:6,i-1);
        % k1 = dt*[v1;a1];
        
        % 2'nd Order
        ep2          = ep1 + 0.5*ev1*dt;
        ev2          = ev1 + 0.5*ea1*dt;
        ea2          = (-mu_lunar - mu_earth ) / sqrt( ep2' * ep2 ) ^ 3 * ep2;

        r2 = r1+0.5*v1*dt;
        r2e = r2-ep2;
        v2  = v1+0.5*a1*dt;
        a2  = - mu_lunar / sqrt( r2' * r2 )^3 * r2 - mu_earth / sqrt( r2e' * r2e ) ^ 3 * r2e - mu_earth / sqrt( ep2' * ep2 ) ^ 3 * ep2;
        % k2 = dt*[v2;a2];
    
        % 3'rd Order
        ep3          = ep1 + 0.5*ev2*dt;
        ev3          = ev1 + 0.5*ea2*dt;
        ea3          = (-mu_lunar - mu_earth ) / sqrt( ep3' * ep3 ) ^ 3 * ep3;

        r3 = r1+0.5*v2*dt;
        r3e = r3-ep3;
        v3  = v1+0.5*a2*dt;
        a3  = - mu_lunar / sqrt( r3' * r3 )^3 * r3 - mu_earth / sqrt( r3e' * r3e ) ^ 3 * r3e- mu_earth / sqrt( ep3' * ep3 ) ^ 3 * ep3;
        % k3 = dt*[v3;a3];
    
        % 4'th Order
        ep4          = ep1 + ev3*dt;
        ev4          = ev1 + ea3*dt;
        ea4          = (-mu_lunar - mu_earth ) / sqrt( ep4' * ep4 ) ^ 3 * ep4;

        r4 = r1+v3*dt;
        r4e = r4-ep4;
        v4  = v1+a3*dt;
        a4  = - mu_lunar / sqrt( r4' * r4 )^3 * r4 - mu_earth / sqrt( r4e' * r4e ) ^ 3 * r4e- mu_earth / sqrt( ep4' * ep4 ) ^ 3 * ep4;
        % k4 = dt*[v4;a4];


        % Sum Orders
        
        % 1'st Order Update
        ep1 = (2*ep2 + 4*ep3 + (2*ev3 + ev4)*dt)/6;
        ev1 = (2*ev2 + 4*ev3 + (2*ea3 + ea4)*dt)/6;
        ea1 = (-mu_lunar - mu_earth ) / sqrt( ep1' * ep1 ) ^ 3 * ep1;

        r1 = (2*r2 + 4*r3 + (2*v3 + v4)*dt)/6;
        r1e = r1 - ep1;
        v1  = (2*v2 + 4*v3 + (2*a3 + a4)*dt)/6;
        a_earth     = - mu_earth / sqrt( r1e' * r1e ) ^ 3 * r1e;
        a_lunar     = - mu_lunar / sqrt( r1' * r1 ) ^ 3 * r1;
        a1 = a_lunar+a_earth - mu_earth / sqrt( ep1' * ep1 ) ^ 3 * ep1;
        
        g_earth(:,i) = a_earth;
        g_lunar(:,i) = a_lunar;

                % Lunar Update
        earth_pos(:,i) = ep1;
        earth_vel(:,i) = ev1;

        pos(:,i) = r1;
        vel(:,i) = v1;
        % y(:,i) = [kk ; 2*v2 + 4*v3 + (2*a3 + a4)*dt]/6;
        % y(:,i) = y(:,i-1) + [v1+2*v2+2*v3+v4;a1+2*a2+2*a3+a4]*dt/6;
        % y(:,i) = y(:,i-1) + (k1+2*k2+2*k3+k4)/6;
        %End RK4



        if (i-2)*dt > 24*3600*4
            Lunar_orb.orb = -[earth_pos(:,1:i-1);earth_vel(:,1:i-1)];

            mission_orb.orb  =  [pos(:,1:i-1)-earth_pos(:,1:i-1); vel(:,1:i-1)-earth_vel(:,1:i-1)];
            mission_orb.earth_gravity = g_earth(:,1:i-1);
            mission_orb.lunar_gravity = g_lunar(:,1:i-1);
            
            mission_orb.T = (i-2)*dt;
            break;
        end

        i = i+1;
        
    end
end