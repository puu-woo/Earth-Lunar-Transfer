function [launch_RA,launch_lat,lunar_posAtarrival,lunar_velAtarrival,launch_dateUTC] = launchwindow(lon,algorithm_dateUTC,TOF,inc_trans)
%% Revision history
%   - 2023/04/08, by 은별
%   - 2023/04/10, by 동민
%   - 2023/04/21, by 은별
%   - 2023/04/21, by 동민
%   - 2023/04/21, by 은별
%   - 2023/04/22, by 동민
%   - 2023/04/24, by 동민
%=========================================================================
% input value    : longitude         : in degree
% input value    : algorithm_date    : in datetime[year,month,date,hour,minute,second]
% 
% input example  : launchwindow(130,[2023,6,10,12,0,0])
%=========================================================================


algorithm_date_jul              =   juliandate ( algorithm_dateUTC );

startDate                       =   datetime ( algorithm_dateUTC );

% Create an array of datetime values with an interval of 10 minutes
datetimeArray                   =   startDate : minutes(1) : startDate + days(5);


% datetimeArray convert to Juliandate Array (to put it in planetEphemeris)
datetimeArray_jul               =   juliandate ( datetimeArray+seconds(TOF) )';


% % Relative position of Moon to Earth
[r_Mrel,v_Mrel]                 =   planetEphemeris ( datetimeArray_jul , 'Earth' , 'Moon' );


% %change it into lla form
[lunar_RA,lunar_lat,~]          =   j2000ToRaanLat ( r_Mrel );


% longitude considering the rotation of the Earth
% GMST
% 발사장 위도에 세차 운동이 고려되지 않음
gmst_degree                     =   siderealTime ( algorithm_date_jul );    % greenwich RA
ra_j2000                        =   gmst_degree + lon  + 360 / 24 / 60 * ( 0 : length ( lunar_RA ) - 1 );
ra_j2000_adj                    =   adjust_lon ( ra_j2000 )' * pi / 180;    % convert into radian


% Compare to given longitude
% tolerance in 0.1 degree.
dateNum                         =   1;
tol                             =   0.1 * pi / 180;
for i = 1:length(lunar_RA)
    reverse_lunarRA             =   pi + lunar_RA ( i );
    if reverse_lunarRA > 2*pi
        reverse_lunarRA         =   reverse_lunarRA - 2 * pi;
    end

    if abs ( reverse_lunarRA  - ra_j2000_adj ( i ) ) < tol
            launch_dateUTC(dateNum)         =   datetimeArray ( i );
            launch_lat(dateNum)             =   -lunar_lat ( i )-inc_trans;
            launch_RA(dateNum)              =   ra_j2000_adj ( i );
            lunar_posAtarrival(dateNum,:)   =   r_Mrel ( i,: );
            lunar_velAtarrival(dateNum,:)   =   v_Mrel ( i,: );
            dateNum                         =   dateNum + 1;
    end
        
end

end