function [E_orb,Trans_orb ,LOI_orb ,Lunar_orb] = Earth_LOI_Orb(IConditions)


% Earth Parking Orbit
[E_orb.r0, E_orb.v0]  = EparkOrb ( IConditions.Earth );


% Earth-Lunar Transfer Orbit
v_init                =   [ 0 , -10.6 , 0 ];
[Trans_orb,Lunar_orb_trans]           =   TransOrb( E_orb.r0 , v_init , IConditions );


% LOI maneuver
[LOI_orb,Lunar_orb_inj,min_distance] = LOIOrb(Trans_orb.orb(:,end)',IConditions);


% 
tor          = 1; % tolerance
addtheta     = 0.01;
pre_location = 'OutTarget';

% Solve until min_distance from soi is lower than tolerance
while true
    if min_distance > IConditions.Lunar.h_mission+tor

        if strcmp(pre_location,'InTarget')
            addtheta = addtheta/5;
            pre_location = 'OutTarget';
        end

        IConditions.Earth.theta = IConditions.Earth.theta+addtheta;

        % Earth Parking Orbit
        [E_orb.r0, E_orb.v0]  = EparkOrb ( IConditions.Earth );
        
        
        % Earth-Lunar Transfer Orbit
        v_init                =   [ 0 , -10.6 , 0 ];
        [Trans_orb,Lunar_orb_trans]           =   TransOrb( E_orb.r0 , v_init , IConditions );
        
        
        % LOI maneuver
        [LOI_orb,Lunar_orb_inj,min_distance] = LOIOrb(Trans_orb.orb(:,end)',IConditions);


    elseif min_distance < IConditions.Lunar.h_mission-tor

        if strcmp(pre_location,'OutTarget')
            addtheta = addtheta/5;
            pre_location = 'InTarget';
        end

        IConditions.Earth.theta = IConditions.Earth.theta-addtheta;

        % Earth Parking Orbit
        [E_orb.r0, E_orb.v0]  = EparkOrb ( IConditions.Earth );
        
        
        % Earth-Lunar Transfer Orbit
        v_init                          =   [ 0 , -10.6 , 0 ];
        [Trans_orb,Lunar_orb_trans]     =   TransOrb( E_orb.r0 , v_init , IConditions );
        
        
        % LOI maneuver
        [LOI_orb,Lunar_orb_inj,min_distance] = LOIOrb(Trans_orb.orb(:,end)',IConditions);

    else % min_distance is lower than tor
        break;
    
    end % end if
end % end while

Lunar_orb.trans = Lunar_orb_trans;
Lunar_orb.inj   = Lunar_orb_inj;