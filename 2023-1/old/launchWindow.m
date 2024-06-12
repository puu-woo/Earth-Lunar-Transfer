clear
%==========================================================================
%% Function
%   - find launch site and time of flight over patched conic method
%% Inputs
% Arrival Time
% Radius of three orbits
%% Outputs
% Launch site : latitude, longitude
% Launch date : UTC time
%% Revision history
%   - 2023/04/07, by Dong-Min Moon
%=========================================================================

% Radius of Earth and Moon (km)
radiusOfEarth       =   6378.137;
radiusOfMoon        =   1737.4;


% Gravitational constant (km**3/sec**2)
mu_earth            =   398600.4418;
mu_moom             =   4911.3;

% Arival Date (utc)
year                =   2023;
month               =   6;
day                 =   10;
hours               =   12;
min                 =   0;
sec                 =   0;
date                =   [ year , month , day , hours , min , sec ];
JD                  =   juliandate ( date );


% Moon Position, Longitude, Latitude (km) in j2000
[moonPosf , moonVelf , lat_moonf , lon_moonf, moonPosfNorm] = moonPosition( JD );


% Orbit radius from central body (km)
rEarthOrb           =   radiusOfEarth + 500;
rInjOrb             =   radiusOfMoon + 1000;
rTgOrb              =   radiusOfMoon + 100;


% Orbit distance from earth (km)
rInjOrbFrome        =   moonPosfNorm - rInjOrb;


% Orbit Velocity (km/s)
v1                  =   sqrt( mu_earth / rEarthOrb );
v1_                 =   sqrt( 2 * mu_earth / rEarthOrb - 2 / ( rEarthOrb + rInjOrbFrome ) );

v2                  =   sqrt( 2 * mu_earth / rInjOrbFrome - 2 / ( rEarthOrb + rInjOrbFrome ) );
v2_                 =   sqrt( 2 * mu_moom / rInjOrb - 2 / ( rTgOrb + rInjOrb ) );

v3                  =   sqrt( 2 * mu_moom / rTgOrb - 2 / ( rTgOrb + rInjOrb ) );
v3_                 =   sqrt( mu_moom / rTgOrb );


% Delta Velocity (km/s)
dv1                 =   v1_ - v1;
dv2                 =   v2_ - v2;
dv3                 =   v3_ - v3;


% Time Of Flight (s)
T1                  =   pi * sqrt( ( ( rEarthOrb + rInjOrbFrome ) / 2 ) ^3 / mu_earth );
T2                  =   pi * sqrt( ( ( rTgOrb + rInjOrb ) / 2 ) ^3 / mu_moom );
TT                  =   T1 + T2;


% Launch Date
Launch_DateJD       =   JD - TT / 86400;
launch_dateUTC      =   datetime( JD - TT / 86400 , 'convertfrom' , 'juliandate' );


% Moon Position at Final (km) in j2000
[moonPosi , moonVeli, lat_mooni , lon_mooni, moonPosiNorm ] = moonPosition ( Launch_DateJD );


% Required Launch Site for Patched Conic method
launch_site         =   - moonPosf / moonPosfNorm * rEarthOrb;


% Lunar Orbit
lunar_oev           = eci2orb ( mu_earth , moonPosf , moonVelf );
lunar_orb           = oev2eci ( lunar_oev );



% Viewer
view(3)
p1 = plot3(lunar_orb(1,:),lunar_orb(2,:),lunar_orb(3,:));
hold on
p2 = plot3(moonPosi(1),moonPosi(2),moonPosi(3),'Marker','o','Color',[0.8,0,0]);
p3 = plot3(moonPosf(1),moonPosf(2),moonPosf(3),'Marker','o','MarkerFaceColor',[0.8,0,0]);
p4 = plot3(launch_site(1),launch_site(2),launch_site(3),'Marker','o','Color','b');
hold off
grid on
xlim([-4,4]*10^5); xlabel('x')
ylim([-4,4]*10^5); ylabel('y')
zlim([-4,4]*10^5)
legend([p1,p2,p3,p4],{'Lunar Orbit','Initial lunar pos','Final lunar pos','Launch Site'},'Location','best')


