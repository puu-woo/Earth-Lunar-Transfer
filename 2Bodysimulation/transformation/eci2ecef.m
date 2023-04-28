function r_ecef = eci2ecef(r_eci, jd)
% input : r_eci in kilometer, jd for julian date


% Define the Julian centuries since J2000
T = (jd - 2451545.0) / 36525.0;

% Define the Greenwich Mean Sidereal Time
GMST        =      280.46061837 + 360.98564736629*(jd - 2451545.0) + 0.000387933*T^2 - T^3/38710000;

% adjust the GMST
% 기존 adjust_lon 도 간단히 가능
GMST        =       mod ( GMST , 360 ) * pi / 180;

% DCM
DCM_eci2ecef    =   [cos(GMST)      sin(GMST)       0;
                    -sin(GMST)      cos(GMST)       0;
                    0               0               1];

% Convert the ECI coordinates to ECEF coordinates
r_ecef = DCM_eci2ecef * r_eci;