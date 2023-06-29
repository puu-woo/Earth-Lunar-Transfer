function r0_rot = rotation_theta(r0)
% to go inner ellipse transfer orbit
% theta is random value : must be optimized
% the rotation is about W axis in PQW

theta = -10 * pi / 180;

DCM = [ cos(theta)     sin(theta)     0;
        -sin(theta)    cos(theta)     0;
        0               0             0];

r0_rot  =   r0 * DCM;

end