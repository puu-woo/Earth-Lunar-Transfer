function [delv,periods] = findDelvTOF(EarthOrbitRadius,injectionRadius,missionAltitude,lunar_distance,mu_earth,mu_moon,EarthRadius,LunarRadius)
%% Revision history
%   - 2023/04/22, by 찬우
%   - 2023/04/24, by 동민
%=========================================================================

r_mission           =   LunarRadius + missionAltitude;

r0                  =   EarthRadius + EarthOrbitRadius;
a_trans             =   ( lunar_distance - injectionRadius + r0 ) / 2;
a_injec             =   ( injectionRadius + r_mission ) / 2;

v0                  =   sqrt ( mu_earth / r0 );
v0_                 =   sqrt ( mu_earth * ( 2 / r0 - 1 / a_trans ) );


v1                  =   sqrt ( mu_earth * ( 2 / ( lunar_distance - injectionRadius ) - 1 / a_trans ) );
v1_                 =   sqrt ( mu_moon * ( 2 / injectionRadius - 1 / a_injec ) );


v2                  =   sqrt ( mu_moon * ( 2 / r_mission - 1 / a_injec ) );
v2_                 =   sqrt ( mu_moon / r_mission );

T_trans             =   pi * sqrt ( a_trans ^3 / mu_earth );
T_injec             =   pi * sqrt ( a_injec ^3 / mu_moon );

delv(1) = v0_-v0;
delv(2) = v1_-v1;
delv(3) = v2_-v2;
periods(1) = T_trans;
periods(2) = T_injec;

end