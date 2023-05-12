function [r,v] = EparkOrb(mu_earth,h)

r = [-h,0,0];
v = [0,-sqrt( mu_earth / h),0];