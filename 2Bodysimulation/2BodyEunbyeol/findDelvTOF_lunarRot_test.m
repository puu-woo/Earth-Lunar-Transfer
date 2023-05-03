% FindDelvTOF_lunarRot test code

% Constant
inc                         =   0.5 * pi;
mu_earth                    =   398600.4418;
mu_moon                     =   4911.3;
EarthRadius                 =   6378;
LunarRadius                 =   1743;

% inputs
EarthOrbitaltitude          =   400;
injectionRadius             =   60000;
missionAltitude             =   100;
lon_songdo                  =   126.659167;
searchStartdate             =   [ 2023 , 12 , 25, 0 , 0 , 0 ];


% lunar_distance at main.m
jd                          =   juliandate([ 2023 , 12 , 25, 0 , 0 , 0 ]);
r_lunar                     =   planetEphemeris(jd,'Earth','Moon');
lunar_distance              =   sqrt(sum(r_lunar.^2));


%===============================================================================
% The test code starts here.

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
v0_                 =   sqrt ( mu_earth * ( 2 / r0 - 1 / a_trans ) )


v1                  =   sqrt ( mu_earth * ( 2 / ( a_trans - r0 ) - 1 / a_trans ) );
v1_                 =   sqrt ( mu_moon * ( 2 / injectionRadius - 1 / a_injec ) )


v2                  =   sqrt ( mu_moon * ( 2 / r_mission - 1 / a_injec ) );
v2_                 =   sqrt ( mu_moon / r_mission )

%================================================================================
% editted code starts here


T_trans             =   pi * sqrt ( a_trans ^3 / mu_earth );
T_injec             =   pi * sqrt ( a_injec ^3 / mu_moon );

delv(1) = v0_-v0;
delv(2) = v1_-v1;
delv(3) = v2_-v2;
periods(1) = T_trans;
periods(2) = T_injec;