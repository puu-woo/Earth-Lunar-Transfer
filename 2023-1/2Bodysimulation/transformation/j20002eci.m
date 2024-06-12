function r_eci = j20002eci(j2000, jd)
% input : j2000 in kilometer, jd for julian date


% Define the Julian centuries since J2000
T       =       ( jd - 2451545.0 ) / 36525.0;

% DCM
theta   =       ( 23.439291 - 0.0130042 * T - 1.64e-07 * T^2 + 5.04e-07 * T^3 ) * pi/180;
DCM_j20002eci       =   [cos(theta)       sin(theta)    0;
                         -sin(theta)      cos(theta)    0;
                         0                0             1];

% Convert the J2000 coordinates to ECI coordinates
r_eci = DCM_j20002eci * j2000;