function me = ecef2me(ecef, jd)


% Define the Julian centuries since J2000
T = (jd - 2451545.0) / 36525.0;

% GMST and DCM
GMST              =     280.46061837 + 360.98564736629*(jd - 2451545.0) + 0.000387933*T^2 - T^3/38710000;
DCM_ecef2j2000    =     [cos(GMST)      sin(GMST)       0;
                        -sin(GMST)     cos(GMST)       0;
                        0              0               1];

DCM_J20002me      =     [1 0 0; 0 1 0; 0 0 1];          % b/c : r_ECI = r_ME -> is it right..?

% Define the position vector of the Moon in ECEF coordinates
r_Moon_ECEF     =       planetEphemeris ( jd , 'Earth' , 'Moon' );

% Convert
r_ECEF_J2000    =       DCM_ecef2j2000 * ecef';
r_Moon_J2000    =       DCM_ecef2j2000 * r_Moon_ECEF;
r_ECI           =       r_ECEF_J2000 - r_Moon_J2000';
r_ME            =       DCM_J20002me * r_ECI;

% Return the position vector in Moon-centered (ME) coordinates
me = r_ME';

end

