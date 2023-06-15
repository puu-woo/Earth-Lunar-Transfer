function sat = sat()

sat = {};

% Keplerian Orbit elements
sat.a       = 6900 ;
sat.ecc     = 0;
sat.inc     = 0;
sat.argper  = 0;
sat.raan    = 0;
sat.f       = 0;

% UTC Date ( epoch date )
year    = 2023;
mon     = 6;
day     = 9;
hour    = 3;
min     = 10;
sec     = 0;
sat.UTCdate = [year,mon,day,hour,min,sec];

end