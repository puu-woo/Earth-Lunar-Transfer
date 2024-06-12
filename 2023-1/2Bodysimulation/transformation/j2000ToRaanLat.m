function [raan,lat,altitude] = j2000ToRaanLat(pos)
%% Revision history
%   - 2023/04/06, by Dong-Min Moon
%   - 2023/04/10, by Dong-Min Moon
%=========================================================================
%   input
%   - pos = [x,y,z] in n x 3
%   output
%   - lon, lat : radian
%   - latitude : km
%=========================================================================

altitude        =   sqrt( pos(:,1) .* pos(:,1) + pos(:,2) .* pos(:,2) + pos(:,3) .* pos(:,3) );
raan             =   atan2 ( pos(:,2) , pos(:,1) );
raan(raan<0)      =   raan ( raan < 0 ) + 2*pi;

lat            =   asin ( pos(:,3) ./ altitude );

end

