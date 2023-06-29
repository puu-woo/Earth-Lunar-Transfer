function [r,v] = EparkOrb(Earth_conditions)

mu_earth    = Earth_conditions.mu;
h           = Earth_conditions.h0;
theta       = Earth_conditions.theta;

% r = [-h,0,0];
% v = [0,-sqrt( mu_earth / h),0];

% rotate theta by W axis(PQW)
% DCM = [ cos(theta)     sin(theta)     0;
%         -sin(theta)    cos(theta)     0;
%         0               0             1];

r     =   [-h*cos(0) , h*sin(0) , 0];

vnorm =   sqrt( mu_earth / h);
v     =   [-sin(0)*vnorm , -cos(0)*vnorm , 0];

end