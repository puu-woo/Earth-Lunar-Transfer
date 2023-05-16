function [r,v] = EparkOrb(mu_earth,h)

r = [-h,0,0];
v = [0,-sqrt( mu_earth / h),0];


% rotate theta by W axis(PQW)
r = rotation_theta(r);
v = rotation_theta(v);

end