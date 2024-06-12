function oev = eci2orb(mu,r,v)
%% Revision history
%   - 2023/04/05, by Dong-Min Moon
%=========================================================================
% convert eci state vector to six classical orbital
% elements via equinoctial elements
% input
%  mu = central body gravitational constant (km**3/sec**2)
%  r  = eci position vector (kilometers)
%  v  = eci velocity vector (kilometers/second)
% output
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
% Orbital Mechanics with Matlab
%==========================================================================


% position and velocity norm
rnorm       = sqrt( r(1)*r(1) + r(2)*r(2) + r(3)*r(3) );
vnorm       = sqrt( v(1)*v(1) + v(2)*v(2) + v(3)*v(3) );
rhat        = r / rnorm;


% anguler momentum
h           = cross(r, v);
hnorm       = sqrt( h(1)*h(1) + h(2)*h(2) + h(3)*h(3));


% node vector
n           = cross( [0,0,1] , h );
nnorm       = sqrt( n(1)*n(1) + n(2)*n(2) + n(3)*n(3));


% eccentricity
ecc         = cross(v, h) / mu - rhat;
eccm        = sqrt( ecc(1)*ecc(1) + ecc(2)*ecc(2) + ecc(3)*ecc(3));


% semimajor
a           = 1 / (2 / rnorm - vnorm * vnorm / mu);


% inclination
inc         = acos( h(3) / hnorm );


% raan
raan        = atan2( n(2) , n(1) );



% argument of perigee
if eccm  >  0.00000001
    ndote   = dot( n , ecc );
    argper  = acos( ndote / ( eccm * nnorm ) );


    if ecc(3)  <  0
        argper  = 2*pi - argper;
    end

else
    argper  = 0.0;
end


% true anomaly
rdote       = dot ( r , ecc );
f           = acos ( rdote / ( rnorm * eccm ) );


if ecc(1) * r(2) - ecc(2) * r(1) < 0
    f       = 2*pi - f;
end


oev(1)      = a;
oev(2)      = eccm;
oev(3)      = inc;
oev(4)      = argper;
oev(5)      = raan;
oev(6)      = f;


end