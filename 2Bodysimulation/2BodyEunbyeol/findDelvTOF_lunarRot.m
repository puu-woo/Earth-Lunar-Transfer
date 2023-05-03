function [delv,v0_,v1_,v2_,inc_trans] = findDelvTOF_lunarRot(EarthOrbitaltitude,injectionRadius,missionAltitude,lunar_distance,mu_earth,mu_moon,EarthRadius,LunarRadius)
%% Find delV and TOF of transition and injection orbit that movement due to lunar orbit is applied
%


lunarAxisInc        =       ( 90 - 6.68 ) * pi / 180;               % lunar axis inclination to the lunar's orbit around the earth : 실제값으로 수정 필요
r0                  =       EarthRadius + EarthOrbitaltitude;
r_mission           =       LunarRadius + missionAltitude;


% Length from the Earth's center to the lunar pole stamped on the lunar SOI
% Using cosine law.2
r_lunarInjec        =       sqrt(lunar_distance.^2 + injectionRadius.^2 - 2*lunar_distance*injectionRadius*cos(lunarAxisInc));

% Inclination of Transfer orbit to the lunar's orbit around the earth
% Using sine law
inc_trans           =       asin(injectionRadius * sin(lunarAxisInc) / r_lunarInjec);



a_trans             =       (r0 + r_lunarInjec) / 2;
a_injec             =       (injectionRadius + r_mission) / 2;

v0                  =   sqrt ( mu_earth / r0 );
v0_                 =   sqrt ( mu_earth * ( 2 / r0 - 1 / a_trans ) );


v1                  =   sqrt ( mu_earth * ( 2 / ( a_trans - r0 ) - 1 / a_trans ) );
v1_                 =   sqrt ( mu_moon * ( 2 / injectionRadius - 1 / a_injec ) );


v2                  =   sqrt ( mu_moon * ( 2 / r_mission - 1 / a_injec ) );
v2_                 =   sqrt ( mu_moon / r_mission );

T_trans             =   pi * sqrt ( a_trans ^3 / mu_earth );
%T_injec             =   pi * sqrt ( a_injec ^3 / mu_moon );

delv(1) = v0_-v0;
delv(2) = v1_-v1;
delv(3) = v2_-v2;
periods(1) = T_trans;
%periods(2) = T_injec;
end
