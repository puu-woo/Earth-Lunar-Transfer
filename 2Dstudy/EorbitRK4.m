<<<<<<< HEAD
function y = EorbitRK4(stopstep,dt,y0)
    mu_earth                    =   398600;
    y(:,1) = y0;
    for i = 2:stopstep
=======
function [y,min_distance,T] = EorbitRK4(dt,y0,lunar_posATinj,lunar_SOI)
    mu_earth                    =   398600;
    y(:,1) = y0;
    i = 2;
    distance = norm(lunar_posATinj);
    min_distance = distance;
    while true
>>>>>>> main
        r1 = y(1:3,i-1);
        v1 = y(4:6,i-1);
        a1 = - mu_earth / sum ( r1.^2 )^(1.5) * r1;
        k1 = dt*[v1;a1];
    
<<<<<<< HEAD
        r2 = y(1:3,i-1)+0.5*k1(1:3);
        v2 = y(4:6,i-1)+0.5*k1(4:6);
        a2 = - mu_earth / sum ( r2.^2 )^(1.5) * r2;
        k2 = dt*[v2;a2];
    
        r3 = y(1:3,i-1)+0.5*k2(1:3);
        v3 = y(4:6,i-1)+0.5*k2(4:6);
        a3 = - mu_earth / sum ( r3.^2 )^(1.5) * r3;
        k3 = dt*[v3;a3];
    
        r4 = y(1:3,i-1)+k3(1:3);
        v4 = y(4:6,i-1)+k3(4:6);
=======
        r2 = r1+0.5*k1(1:3);
        v2 = v1+0.5*k1(4:6);
        a2 = - mu_earth / sum ( r2.^2 )^(1.5) * r2;
        k2 = dt*[v2;a2];
    
        r3 = r1+0.5*k2(1:3);
        v3 = v1+0.5*k2(4:6);
        a3 = - mu_earth / sum ( r3.^2 )^(1.5) * r3;
        k3 = dt*[v3;a3];
    
        r4 = r1+k3(1:3);
        v4 = v1+k3(4:6);
>>>>>>> main
        a4 = - mu_earth / sum ( r4.^2 )^(1.5) * r4;
        k4 = dt*[v4;a4];
    
        y(:,i) = y(:,i-1) + (k1+2*k2+2*k3+k4)/6;
<<<<<<< HEAD
=======

        pre_distance = distance;
        distance = norm(lunar_posATinj'-y(1:3,i))-lunar_SOI;
        
        if distance < min_distance
            min_distance = distance;
        end

        if distance > pre_distance
            y = y(:,1:end-1);
            T = (i-2)*5;
            break;
        end
        i = i+1;
>>>>>>> main
    end
end