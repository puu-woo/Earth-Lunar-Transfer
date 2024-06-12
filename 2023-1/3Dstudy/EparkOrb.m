function [IConditions] = EparkOrb(IConditions)

mu_earth    = IConditions.Earth.mu;
h           = IConditions.Earth.h0;
raan        = IConditions.Earth.raan;
inc         = IConditions.Earth.inc;
f           = IConditions.Earth.f;
vn_init_pq  = IConditions.Earth.vInitpq;


r = [h,0,0]';
v = [0,sqrt( mu_earth / h),0]';


% rotate theta by W axis(PQW)
DCM = DCMeci2pq(f,inc,raan);

IConditions.Earth.r0     =   DCM'*r;
IConditions.Earth.v0     =   DCM'*v;
IConditions.Earth.v_init =   DCM'*vn_init_pq;

end