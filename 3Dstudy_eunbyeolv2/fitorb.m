function [trans_orb , Lunar_orb_trans , IConditions, mission_orb , Lunar_orb_mission] = fitorb(IConditions , lunar_posInit)


%solve at first time
IConditions = EparkOrb(IConditions);
[trans_orb , Lunar_orb_trans , IConditions]  =   transfer( IConditions , lunar_posInit );
[mission_orb , Lunar_orb_mission]            =   maneuver(trans_orb.orb(:,end) , Lunar_orb_trans.orb(:,end) , IConditions);


% Results
% results.IConditions = IConditions;
% 
% results.transferOrb   = trans_orb.orb;
% results.missionOrb    = mission_orb.orb;
% results.TOF           = [trans_orb.T,   mission_orb.T];
% results.totalOrb      = [trans_orb.orb, mission_orb.orb];
% 
% results.transferOev   = trans_orb.oev;
% results.missionOev    = mission_orb.oev;
% 
% results.earth_gravity = mission_orb.earth_gravity;
% results.lunar_gravity = mission_orb.lunar_gravity;
% 
results.dv_vector1    = IConditions.Earth.v_init - IConditions.Earth.v0;
results.dv_vector2    = mission_orb.orb(4:6,1) - trans_orb.orb(4:6,end);
results.dv_norms      = [norm(results.dv_vector1) , norm(results.dv_vector2)];
% 
% results.lunarOrb_atTrans   = Lunar_orb_trans.orb;
results.lunarOrb_atMission = Lunar_orb_mission.orb;
% results.totalLunarOrb      = [Lunar_orb_trans.orb , Lunar_orb_mission.orb];

% lunarOrb_atTrans = results.lunarOrb_atTrans;
lunarOrb_atManeuver = results.lunarOrb_atMission;
% lunarOrb = results.totalLunarOrb;

%Rel_pos1 = transfer_orb(1:3,:)-lunarOrb_atTrans(1:3,:);
Rel_pos2 = mission_orb(1:3,:)-lunarOrb_atManeuver(1:3,:);

offset                     =   abs(vecnorm(Rel_pos2)-IConditions.Lunar.h_mission);
offset_max                 =   max(offset);
offset_tol                 =   0.1;      %[in kilometer]
delV_min                   =   3.5;


%raan->inc->argper
while true

    if offset_max > offset_tol
        IConditions.Earth.inc = Iconditions.Earth.inc + addtheta;
        IConditions = EparkOrb(Iconditions);
        [trans_orb , Lunar_orb_trans , IConditions]  =   transfer( IConditions , lunar_posInit );
        [mission_orb , Lunar_orb_mission]            =   maneuver(trans_orb.orb(:,end) , Lunar_orb_trans.orb(:,end) , IConditions);
        lunarOrb_atManeuver = Lunar_orb_mission.orb;
        Rel_pos2 = mission_orb(1:3,:)-lunarOrb_atManeuver(1:3,:);
        offset                     =   vecnorm(Rel_pos2)-IConditions.Lunar.h_mission;
        offset_max                 =   max(offset);
        results.dv_vector1    = IConditions.Earth.v_init - IConditions.Earth.v0;
        results.dv_vector2    = mission_orb.orb(4:6,1) - trans_orb.orb(4:6,end);
        results.dv_norms      = [norm(results.dv_vector1) , norm(results.dv_vector2)];
        delV                  = sum(results.dv_norms);
    elseif delV > delV_min
        IConditions.Earth.inc = Iconditions.Earth.inc + addtheta;
        IConditions = EparkOrb(Iconditions);
        [trans_orb , Lunar_orb_trans , IConditions]  =   transfer( IConditions , lunar_posInit );
        [mission_orb , Lunar_orb_mission]            =   maneuver(trans_orb.orb(:,end) , Lunar_orb_trans.orb(:,end) , IConditions);
        lunarOrb_atManeuver = Lunar_orb_mission.orb;
        Rel_pos2 = mission_orb(1:3,:)-lunarOrb_atManeuver(1:3,:);
        offset                     =   vecnorm(Rel_pos2)-IConditions.Lunar.h_mission;
        offset_max                 =   max(offset);
        results.dv_vector1    = IConditions.Earth.v_init - IConditions.Earth.v0;
        results.dv_vector2    = mission_orb.orb(4:6,1) - trans_orb.orb(4:6,end);
        results.dv_norms      = [norm(results.dv_vector1) , norm(results.dv_vector2)];
        delV                  = sum(results.dv_norms);
    else
        break;
    end
    
    
end

    
    