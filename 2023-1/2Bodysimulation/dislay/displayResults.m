%% Revision history
%   - 2023/04/24, by 동민
%=========================================================================

disp(['Launch Date     : ',char(launch_dateUTC(1))])
disp(['Arrival Date    : ',char(launch_dateUTC(1)+seconds(TOF))])
disp(['Time of Flight  : ',num2str(TOF/86400),' days'])

disp(['Total Delta v   : ',num2str(abs(delv(1))+abs(delv(2))+abs(delv(3))),' km/s'])
disp(['Delta v1        : ',num2str(delv(1)),' km/s'])
disp(['Delta v2        : ',num2str(delv(2)),' km/s'])
disp(['Delta v3        : ',num2str(delv(3)),' km/s'])

disp(['Start Longitude : ',num2str(launch_raan(1)*180/pi),' degree'])
disp(['Start Latitude  : ',num2str(launch_argper(1)*180/pi),' degree'])