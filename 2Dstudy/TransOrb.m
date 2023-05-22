function [Trans_orb] = TransOrb(r0,v_init,IConditions)


% Solve First Time
[Trans_orb,min_distance] = EorbitRK4 ([ r0 , v_init ] , IConditions );
% min_distance : minimun distance from lunar soi

tor          = 0.01; % tolerance
addv         = [0,-0.1,0];
pre_location = 'OutSOI';

% Solve until min_distance from soi is lower than tolerance
while true
    if min_distance > tor

        if strcmp(pre_location,'InSOI')
            addv = addv/10;
            pre_location = 'OutSOI';
        end

        v_init = v_init+addv;
        % Solve First Time
        [Trans_orb,min_distance] = EorbitRK4 ([ r0 , v_init ] , IConditions );

    elseif min_distance < -tor

        if strcmp(pre_location,'OutSOI')
            addv = addv/10;
            pre_location = 'InSOI';
        end

        v_init = v_init-addv;
        % Solve First Time
        [Trans_orb,min_distance] = EorbitRK4 ([ r0 , v_init ] , IConditions );
        
    else % min_distance is lower than tor
        break;
    
    end % end if

end % end while