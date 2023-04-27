function [moonPos,moonVel,lat_moon,lon_moon,distance] = moonPosition(JD)
%% Revision history
%   - 2023/04/06, by Dong-Min Moon
%=========================================================================
[ moonPos, moonVel ]                      =   planetEphemeris( JD , 'Earth' , 'Moon' );
[ lat_moon , lon_moon , distance ]        =   j2000Tolla( moonPos );

end