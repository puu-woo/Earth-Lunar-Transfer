function [r0, lunar_posAtinj] = arrivalwindow(altitude, R_earth,searchStartDate)

% searchStartDate             =   [ 2023 , 12 , 25, 0 , 0 , 0 ];
arrivalDate                 =   datetime(searchStartDate);
dateAtinj_jul               =   juliandate(arrivalDate);
lunar_posAtinj_j2000        =   planetEphemeris(dateAtinj_jul, 'Earth', 'Moon');
lunar_posAtinj              =   j20002pq(lunar_posAtinj_j2000);
lunar_distance              =   norm(lunar_posAtinj_j2000);

r0  =   lunar_distance + 