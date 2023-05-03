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
% added const
raan_lunar                  =   125.08 * pi / 180;
argper_lunar                =   318.15 * pi / 180;
inc_lunar                   =   ( 5.14 + 23.44 ) * pi / 180;

% inputs
EarthOrbitaltitude          =   400;
injectionRadius             =   60000;
missionAltitude             =   100;
lon_songdo                  =   126.659167;
searchStartdate             =   [ 2023 , 12 , 25, 0 , 0 , 0 ];
searchStartdate_jul         =   juliandate( searchStartdate );
%r0                          =   EarthOrbitaltitude + EarthRadius;  % 여기다 하지 말고 벡터여야 되니깐 startlunar_r로 계산 때리자

% Minimmize Lunar Position Error by recursive method
Meanlunar_distance                =   3.846024957711568e+05;
[Startlunar_r, Startlunar_vel]    =   planetEphemeris ( searchStartdate_jul, 'Earth', 'Moon' );
lunarDistance_tolerance           =   0.001; % km



while (true)
    % Find delta v & periods
    [delv,v0_,v1_,v2_,inc_trans]          =   findDelvTOF_lunarRot ( EarthOrbitaltitude , injectionRadius , missionAltitude,Meanlunar_distance,mu_earth,mu_moon,EarthRadius,LunarRadius);
    % TOF                         =   sum ( periods );
    %======================================================================
    % editted code for TOF starts here
%     v0_j2000                    =   pq2j2000 ( 0, v0_, raan_lunar, inc_trans+inc_lunar, argper_lunar);
%     v1_j2000                    =   pq2j2000 ( 0, v1_, raan_lunar, inc_trans+inc_lunar, argper_lunar);
%     v2_j2000                    =   pq2j2000 ( 0, v2_, raan_lunar, inc_trans+inc_lunar, argper_lunar);
%     
%     v0_ME                       =   v0_j2000 - Startlunar_vel';
%     r0                          =   
%     T1                          =   initconditionToTOF( r0, v0_ME);
%  

    % Launch Window
    [launch_lon,launch_lat,lunar_posAtarrival,lunar_velAtarrival,launch_dateUTC]  =  launchwindow ( lon_songdo , searchStartdate , TOF );
    Newlunar_distance                                          =  sqrt ( sum ( lunar_posAtarrival ( 1 , : ) .^ 2 ) );


    % Compare lunar position
        if ( abs ( Meanlunar_distance - Newlunar_distance ) > lunarDistance_tolerance )
            Meanlunar_distance = Newlunar_distance;
            %여기서 달 속도 새로 또 해줘야되는데 이부분 계산으로 들어갈지 모르겠음
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