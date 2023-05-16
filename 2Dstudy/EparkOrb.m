function [r,v] = EparkOrb(mu_earth,h,theta)

r = [-h,0,0];
v = [0,-sqrt( mu_earth / h),0];

% rotate theta by W axis(PQW)

DCM = [ cos(theta)     sin(theta)     0;
        -sin(theta)    cos(theta)     0;
        0               0             1];

r  =   (DCM * r')';
v  =   (DCM * v')';

end