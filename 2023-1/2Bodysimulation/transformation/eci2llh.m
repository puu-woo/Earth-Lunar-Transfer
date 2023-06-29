function [lat, lon, alt] = eci2llh(x, y, z)
% input : ECI in kilometer



% Define the WGS84 reference ellipsoid parameters
a       =       6378.137;                    % semi-major axis in kilometers
b       =       6356.752;                    % semi-minor axis in kilometers
e       =       sqrt( a^2 - b^2 ) / a;       % eccentricity


% Calculate the longitude
r       =       sqrt(x^2 + y^2 + z^2);
lon     =       atan2( y , x );
lat     =       atan2(z, sqrt(x^2 + y^2));


% Calculate the altitude
N       =       a / sqrt(1 - e^2 * sin( lat )^2);
alt     =       r / cos(lat) - N;