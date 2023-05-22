function [Trans_orb,Lunar_orb_trans] = TransOrb(r0,v_init,IConditions)


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


% Tricky Lunar position at transfer time\
lunar_w = IConditions.Lunar.w;
dt = IConditions.dt;
l = length(Trans_orb.orb);
lunar_pos_trans(:,l+1) = IConditions.Lunar.posATinj;
lunar_vel_trans(:,l+1) = cross(IConditions.Lunar.w,IConditions.Lunar.posATinj);

for i = 1:l
    lunar_pos_trans(:,l+1-i) = lunar_pos_trans(:,l+2-i) - lunar_vel_trans(:,l+2-i)*dt';
    lunar_vel_trans(:,l+1-i) = cross(lunar_w,lunar_pos_trans(:,l+2-i))';
end

Lunar_orb_trans.pos = lunar_pos_trans;
Lunar_orb_trans.vel = lunar_vel_trans;