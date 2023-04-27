function [launch_lon,launch_lat,lunar_posAtarrival,lunar_velAtarrival,launch_dateUTC] = launchwindow(lon,algorithm_dateUTC,TOF)
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
[r_Mrel,v_Mrel]                          =   planetEphemeris ( datetimeArray_jul , 'Earth' , 'Moon' );


% %change it into lla form
[lunar_lon,lunar_lat,~]         =   j2000ToRaanLat ( r_Mrel );


% longitude considering the rotation of the Earth
% GMST
gmst_degree                     =   siderealTime ( algorithm_date_jul );    % greenwich RA
lon_Erot                        =   gmst_degree + lon  + 360 / 24 / 60 * ( 0 : length ( lunar_lon ) - 1 );
lon_Erot_adj                    =   adjust_lon ( lon_Erot )' * pi / 180;    % convert into radian


% Compare to given longitude
% tolerance in 0.1 degree.
dateNum                         =   1;
tol                             =   0.1 * pi / 180;
for i = 1:length(lunar_lon)
    ref                         =   pi + lunar_lon ( i );
    if ref > 2*pi
        ref                     =   ref - 2 * pi;
    end

    if abs ( ref  - lon_Erot_adj ( i ) ) < tol
            launch_dateUTC(dateNum)         =   datetimeArray ( i );
            launch_lat(dateNum)             =   -lunar_lat ( i );
            launch_lon(dateNum)             =   lon_Erot_adj ( i );
            lunar_posAtarrival(dateNum,:)   =   r_Mrel ( i,: );
            lunar_velAtarrival(dateNum,:)   =   v_Mrel ( i,: );
            dateNum                         =   dateNum + 1;
    end
        
end

end