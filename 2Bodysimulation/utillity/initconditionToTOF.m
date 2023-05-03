function TOF = initconditionToTOF(r0, v0)
%% calculate the TOF by inition condition of r, v


mu_earth                    =   398600.4418;

% Angular momentum
h_vec                       =   cross( r0, v0 );
h                           =   norm( h_vec );

% Semi-major axis of orbit
a                           =   h^2 / ( mu_earth * ( 1 - ( h^2 / ( mu_earth * norm(r0) ) )^2 ) );

TOF                         =   pi * sqrt ( a^3 / mu_earth );
end