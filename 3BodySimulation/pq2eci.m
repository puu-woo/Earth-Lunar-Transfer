function posECI = pq2eci(p,q, raan,inc,argper)
%% Revision history
%   - 2023/04/07, by Dong-Min Moon
%=========================================================================

ci          =   cos ( inc ); si = sin ( inc );
cw          =   cos ( argper ); sw = sin ( argper );
cr          =   cos ( raan ); sr = sin ( raan );

swci        =   sw * ci;
cwci        =   cw * ci;

posECI(1,:)    =   ( cw * cr - swci * sr ) * p + ( -sw * cr - cwci * sr ) * q;
posECI(2,:)    =   ( cw * sr + swci * cr ) * p + ( -sw * sr + cwci * cr ) * q;
posECI(3,:)    =   sw * si * p + cw * si * q;

end