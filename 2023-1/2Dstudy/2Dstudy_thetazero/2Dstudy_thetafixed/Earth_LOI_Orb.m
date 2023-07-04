function [E_orb,Trans_orb ,LOI_orb ,Lunar_orb] = Earth_LOI_Orb(IConditions)


% Earth Parking Orbit
[E_orb.r0, E_orb.v0]  = EparkOrb ( IConditions.Earth );


% Earth-Lunar Transfer Orbit
v_init                =   -9;
[Trans_orb,Lunar_orb_trans]           =   TransOrb( E_orb.r0 , v_init , IConditions );


% LOI maneuver
v_init_loi                =   Trans_orb.orb(4:6,end)+[0.3,0.7,0]'
[LOI_orb,Lunar_orb_inj,min_distance] = LOIOrb(v_init_loi,Trans_orb.orb(:,end)',IConditions);

% 
% % 
tor          = 0.01; % tolerance
addV     = 0.001;
pre_location = 'OutTarget';

% Solve until min_distance from soi is lower than tolerance

% while true
%     if min_distance > IConditions.Lunar.h_mission+tor
%         
%         if strcmp(pre_location,'InTarget')
%             addV = addV / 10;
%             pre_location = 'OutTarget';
%         end
% 
% %         ang = getAngleFromPoint([0,0,0],Trans_orb.orb(1:3,end)')
% 
%         v_init_loi                =   v_init_loi + [0,addV,0]
%         
%         % LOI maneuver
%         [LOI_orb,Lunar_orb_inj,min_distance] = LOIOrb(v_init_loi,Trans_orb.orb(:,end)',IConditions);
% 
%     elseif min_distance < IConditions.Lunar.h_mission-tor
% 
%         if strcmp(pre_location,'OutTarget')
%             addV = addV / 10;
%             pre_location = 'InTarget';
%         end
% 
% %         ang = getAngleFromPoint([0,0,0],Trans_orb.orb(1:3,end)')
% 
%         v_init_loi                =   v_init_loi - [0,addV,0]';
%         
%         % LOI maneuver
%         [LOI_orb,Lunar_orb_inj,min_distance] = LOIOrb(v_init_loi,Trans_orb.orb(:,end)',IConditions);
% 
%     else % min_distance is lower than tor
%         break;
% 
%     end % end if
% end % end while
% 
Lunar_orb.trans = Lunar_orb_trans;
Lunar_orb.inj   = Lunar_orb_inj;