function [LOI_orb,Lunar_orb,min_distance] = LOIOrb(orb0,IConditions)


[LOI_orb,Lunar_orb,min_distance] = LorbitRK4(orb0,IConditions);


% tor = 0.01;
% addv = [0,0.001,0];
% pre_level = '+';
% while true
%     min_distance
%     if min_distance > tor
%         if pre_level == '-'
%             addv = addv/10;
%         end
%         pre_level = '+';
%         v_init = v_init+addv;
%         [orb_loi,min_distance,T] = LorbitRK4(dt,[r0,v_init],lunar_posATinj);
%     elseif min_distance < -tor
%         if pre_level == '+'
%             addv = addv/10;
%         end
%         pre_level = '-';
% 
%         v_init = v_init-addv;
%         [orb_loi,min_distance,T] = LorbitRK4(dt,[r0,v_init],lunar_posATinj);
%     else
%         break;
%     end
% end