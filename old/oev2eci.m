function pqw = oev2eci(oev)
%% Revision history
%   - 2023/04/07, by Dong-Min Moon
%=========================================================================
%  oev(1) = semimajor axis (kilometers)
%  oev(2) = orbital eccentricity (non-dimensional)
%           (0 <= eccentricity < 1)
%  oev(3) = orbital inclination (radians)
%           (0 <= inclination <= pi)
%  oev(4) = argument of perigee (radians)
%           (0 <= argument of perigee <= 2 pi)
%  oev(5) = right ascension of ascending node (radians)
%           (0 <= raan <= 2 pi)
%  oev(6) = true anomaly (radians)
%           (0 <= true anomaly <= 2 pi)
%==========================================================================

nu          =   linspace ( 0 , 2*pi , 10000 );
rorb        =   oev(1) * ( 1 - oev(2) * oev(2) ) ./ ( 1 + oev(2) * cos( nu ) );

p           =   rorb .* cos ( nu );
q           =   rorb .* sin ( nu );

ci          =   cos ( oev(3) ); si = sin ( oev(3) );
cw          =   cos ( oev(4) ); sw = sin ( oev(4) );
cr          =   cos ( oev(5) ); sr = sin ( oev(5) );

swci        =   sw * ci;
cwci        =   cw * ci;

pqw(1,:)    =   ( cw * cr - swci * sr ) * p + ( -sw * cr - cwci * sr ) * q;
pqw(2,:)    =   ( cw * sr + swci * cr ) * p + ( -sw * sr + cwci * cr ) * q;
pqw(3,:)    =   sw * si * p + cw * si * q;


end