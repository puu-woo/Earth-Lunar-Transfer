% Constant
D2R                         =   pi / 180;
inc                         =   90 * D2R;
simTime                     =   24*3600*20;
dt                          =   10;

% Earth & Lunar Constans
mu_earth                    =   398600.4418;
mu_moon                     =   4911.3;
EarthRadius                 =   6374;
LunarRadius                 =   1700;


% Orbit Trajectory
RadiusOfEarthOrbit          =   EarthRadius + 500;
RadiusOfInjectionOrbit      =   20000;
RadiusOfMissionOrbit        =   LunarRadius + 100;


% Launch Site
lon_songdo                                              =    126.659167 * pi / 180;
searchStartdate                                         =    [ 2023 , 6 , 10 , 12 , 0 , 0 ];
[launch_lon,launch_lat,lunar_pos,lunar_vel,arrival_dateUTC]        =    launchwindow ( lon_songdo , searchStartdate );
lunar_distance                                          =   sqrt ( sum ( lunar_pos .^2 ) );
raan                                                    =   launch_lon ( 1 ) ;
argper                                                  =   launch_lat ( 1 ) ;


% initial Condition
v0                  =   sqrt ( mu_earth / RadiusOfEarthOrbit );
initial_position    =   -RadiusOfEarthOrbit * lunar_pos / lunar_distance;
initial_velocity    =   pq2eci ( 0 , v0 , raan , inc , argper );


% Find Delta v1
a_trans             =   ( lunar_distance - RadiusOfInjectionOrbit + RadiusOfEarthOrbit ) / 2;
v0_                 =   sqrt ( mu_earth * ( 2 / RadiusOfEarthOrbit - 1 / a_trans ) );
delta_v1            =   pq2eci ( 0 , v0_ - v0 , raan , inc , argper );


% Fine Delta v2
v1                  =   sqrt ( mu_earth * ( 2 / ( lunar_distance - RadiusOfInjectionOrbit ) - 1 / a_trans ) );
a_injec             =   ( RadiusOfInjectionOrbit + RadiusOfMissionOrbit ) / 2;
v1_                 =   sqrt ( mu_moon * ( 2 / RadiusOfInjectionOrbit - 1 / a_injec ) );
delta_v2            =   -pq2eci ( 0 , v1_ - v1 , raan , inc , argper )+lunar_vel';


% Fine Delta v3
v2                  =   sqrt ( mu_moon * ( 2 / RadiusOfMissionOrbit - 1 / a_injec ) );
v2_                 =   sqrt ( mu_moon / RadiusOfMissionOrbit );
delta_v3            =   pq2eci ( 0 , v2_ - v2 , raan , inc , argper );
% delta_v3            =   lunar_vel';

% Fine TOF
T_trans             =   pi * sqrt ( a_trans ^3 / mu_earth )-20000;
T_injec             =   pi * sqrt ( a_injec ^3 / mu_moon );
TOF                 =   T_trans;

t4 = 48000;
delv4 = [-0,0,0];
% get Lunar positions
JDarrival           =   juliandate ( arrival_dateUTC );
JDlaunch            =   JDarrival - TOF / 86400 ;


% % Relative position of Moon to Earth
[lunar,lunar_vvel]  =   planetEphemeris ( JDarrival , 'Earth' , 'Moon' );
lunar_orb           =   oev2eci ( eci2orb ( mu_earth , lunar , lunar_vvel ) );
