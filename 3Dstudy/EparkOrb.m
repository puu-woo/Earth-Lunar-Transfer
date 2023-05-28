function [IConditions] = EparkOrb(IConditions, vn_init_pq)

mu_earth    = IConditions.Earth.mu;
h           = IConditions.Earth.h0;
raan        = IConditions.Earth.raan;
inc         = IConditions.Earth.inc;
w           = IConditions.Earth.w;


r = [h,0,0]';
v = [0,sqrt( mu_earth / h),0]';

% rotate theta by W axis(PQW)
DCM_w = [ cos(-w),     sin(-w),     0;
         -sin(-w),    cos(-w),     0;
         0,               0,             1];

DCM_inc = [1 , 0 , 0;
        0 , cos(-inc), sin(-inc);
        0 , -sin(-inc), cos(-inc) ];

DCM_raan = [ cos(-raan),     sin(-raan),     0;
            -sin(-raan),    cos(-raan),     0;
            0,               0,             1];

IConditions.Earth.r0     =   DCM_raan*DCM_inc*DCM_w*r;
IConditions.Earth.v0     =   DCM_raan*DCM_inc*DCM_w*v;
IConditions.Earth.v_init =   DCM_raan*DCM_inc*DCM_w*vn_init_pq;

end