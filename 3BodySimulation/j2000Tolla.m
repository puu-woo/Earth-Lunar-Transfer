function [lon,lat,altitude] = j2000Tolla (pos)
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
lon             =   atan2 ( pos(:,2) , pos(:,1) );
lon(lon<0)      =   lon ( lon < 0 ) + 2*pi;

lat            =   asin ( pos(:,3) ./ altitude );

end

