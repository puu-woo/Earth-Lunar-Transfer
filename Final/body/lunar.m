function Lunar = lunar()

Lunar = {};

Lunar.mu        = 4911.3; % km^3/s^2
Lunar.Radius    = 1737.4; % km
Lunar.getPosVel = @(center, UTCdate) getPosition(center, UTCdate);

end



function [pos, vel] = getPosition(center, UTCdate)

    [pos, vel] = planetEphemeris(juliandate(UTCdate),center,'Moon');

end