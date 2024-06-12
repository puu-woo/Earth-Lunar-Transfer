function j2000 = llh2j2000(lat, lon, alt)
% input : alt in kilometer, lat lon in radian

% Define the WGS84 reference ellipsoid parameters
a       =       6378.137;                    % semi-major axis in kilometers
b       =       6356.752;                    % semi-minor axis in kilometers
e       =       sqrt( a^2 - b^2 ) / a;       % eccentricity

% Convert the llh to ECEF coordinates
N       =       a / sqrt ( 1 - e^2 * sin ( lat )^2 );
x       =       ( N + alt ) * cos ( lat ) * cos ( lon );
y       =       ( N + alt ) * cos ( lat ) * sin ( lon );
z       =       ( N * ( 1 - e^2 ) + alt ) * sin ( lat );

% DCM
theta               =       0.7790572732640;        % Earth Rotation Angle at J2000 epoch in radians
DCM_llh2j2000       =       [cos(theta)     sin(theta)      0;
                            -sin(theta)     cos(theta)      0;
                            0               0               1];

% Convert the ECEF coordinates to J2000 coordinates
j2000       =       DCM_llh2j2000 * [ x, y, z ]';