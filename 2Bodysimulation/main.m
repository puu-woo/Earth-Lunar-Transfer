%% Revision history
%   - 2023/04/22, by 동민
%   - 2023/04/24, by 동민
%=========================================================================
format long
addpath('.\transformation\','.\utillity\','dislay\')
clear

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


% Minimmize Lunar Position Error by recursive method
Meanlunar_distance          =   3.846024957711568e+05;
lunarDistance_tolerance     =   0.001; % km


while (true)
    % Find delta v & periods
    [delv,periods]              =   findDelvTOF ( EarthOrbitaltitude , injectionRadius , missionAltitude,Meanlunar_distance,mu_earth,mu_moon,EarthRadius,LunarRadius);
    TOF                         =   sum ( periods );
 

    % Launch Window
    [launch_lon,launch_lat,lunar_posAtarrival,lunar_velAtarrival,launch_dateUTC]  =  launchwindow ( lon_songdo , searchStartdate , TOF );
    Newlunar_distance                                          =  sqrt ( sum ( lunar_posAtarrival ( 1 , : ) .^ 2 ) );


    % Compare lunar position
        if ( abs ( Meanlunar_distance - Newlunar_distance ) > lunarDistance_tolerance )
            Meanlunar_distance = Newlunar_distance;
        else
            break
        end

end


% PQ frame to ECI frame
raan                    =   launch_lon ( 1 ) ;
argper                  =   launch_lat ( 1 ) ;
initial_position        =   pq2j2000 ( EarthRadius + EarthOrbitaltitude , 0 , raan , inc , argper );
initial_velocity        =   pq2j2000 ( 0 , sqrt ( mu_earth / ( EarthRadius + EarthOrbitaltitude ) ) , raan , inc , argper );
delv_j2000(1,:)         =   pq2j2000 ( 0 , delv ( 1 ) , raan , inc , argper );
delv_j2000(2,:)         =   pq2j2000 ( 0 ,-delv ( 2 ) , raan , inc , argper );
delv_j2000(3,:)         =   pq2j2000 ( 0 , delv ( 3 ) , raan , inc , argper );


% Dynamics Simulation
simTime                 =   24 * 3600 * 8;
dt                      =   10;
out                     =   sim ( "twobody.slx" );
time                    =   out.posj2000.Time;
posj2000                =   out.posj2000.Data;
velj2000                =   out.velj2000.Data;
posME                   =   out.posMj2000.Data;


viewer;
displayResults;