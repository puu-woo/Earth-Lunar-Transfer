function [r0,v0,y_trans , y_loi ,T_trans , T_loi ,lunar_position_inj , lunar_velocity_inj] = Earth2MissionOrb(mu_earth, h0 , theta_init,lunar_posATinj, lunar_SOI, h_mission, dt)



% Earth Parking Orbit
[r0,v0]         = EparkOrb ( mu_earth , h0 , theta_init );


% Earth-Lunar Transfer Orbit
v_init              =   [ 0 , -10.6 , 0 ];
[y_trans,T_trans]   =   TransOrb( r0 , v_init , lunar_posATinj' , lunar_SOI , dt );

% LOI maneuver
[y_loi,T_loi,lunar_position_inj,lunar_velocity_inj,min_distance] = LOIOrb(y_trans(1:3,end)',y_trans(4:6,end)',lunar_posATinj',dt);



tor          = 1; % tolerance
addtheta     = 0.01;
pre_location = 'OutTarget';

% Solve until min_distance from soi is lower than tolerance
while true
    min_distance-h_mission
    if min_distance > h_mission+tor

        if strcmp(pre_location,'InTarget')
            addtheta = addtheta/10;
            pre_location = 'OutTarget';
        end

        theta_init = theta_init+addtheta;

        [r0,v0]         = EparkOrb ( mu_earth , h0 , theta_init );
        
        
        % Earth-Lunar Transfer Orbit
        v_init              =   [ 0 , -10.6 , 0 ];
        [y_trans,T_trans]   =   TransOrb( r0 , v_init , lunar_posATinj' , lunar_SOI , dt );
        
        % LOI maneuver
        [y_loi,T_loi,lunar_position_inj,lunar_velocity_inj,min_distance] = LOIOrb(y_trans(1:3,end)',y_trans(4:6,end)',lunar_posATinj',dt);


    elseif min_distance < h_mission-tor

        if strcmp(pre_location,'OutTarget')
            addtheta = addtheta/10;
            pre_location = 'InTarget';
        end

        theta_init = theta_init-addtheta;

        [r0,v0]         = EparkOrb ( mu_earth , h0 , theta_init );

        v_init              =   [ 0 , -10.6 , 0 ];
        [y_trans,T_trans]   =   TransOrb( r0 , v_init , lunar_posATinj' , lunar_SOI , dt );
        
        % LOI maneuver
        [y_loi,T_loi,lunar_position_inj,lunar_velocity_inj,min_distance] = LOIOrb(y_trans(1:3,end)',y_trans(4:6,end)',lunar_posATinj',dt);

    else % min_distance is lower than tor
        break;
    
    end % end if

end % end while