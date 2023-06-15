% Earth - Lunar Transfer & maneuver
%
% Dynamic model : CR3BP

addpath("body\","satellite\")
centerBody = earth();
secondBody = lunar();
sat  = sat();


launchDate = sat.UTCdate;
[pos, vel] = secondBody.getPosVel('earth',launchDate);

