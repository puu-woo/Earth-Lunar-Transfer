function [Trans_orb,Lunar_orb_trans,IConditions] = transfer(IConditions,lunar_posInit)

IConditions     =   EparkOrb ( IConditions );

r0 = IConditions.Earth.r0;
v0 = IConditions.Earth.v_init;

[Trans_orb,Lunar_orb_trans, min_distance] = orbitRK89([r0;v0],IConditions,lunar_posInit,"transfer");


addv = [0,0.01,0]';

tor = 1;
pre_state = "bigger";
pre_min_distance = 10^6;

while true
    if min_distance > tor
        if strcmp(pre_state,"smaller")
           IConditions.Earth.vInitpq = IConditions.Earth.vInitpq + addv; 
           addv = addv/2;
           pre_state = "bigger";

        elseif min_distance > pre_min_distance
            IConditions.Earth.vInitpq = IConditions.Earth.vInitpq - 2*addv; 
            addv = addv/2;
            min_distance = 10^6;
        elseif pre_min_distance - min_distance < tor/1000
            disp("no Solution");
            break;
        end


        IConditions.Earth.vInitpq = IConditions.Earth.vInitpq + addv;

    elseif min_distance < -tor
        if strcmp(pre_state,"bigger")
           IConditions.Earth.vInitpq = IConditions.Earth.vInitpq - addv; 
           addv = addv/2;
           pre_state = "smaller";

        elseif min_distance < pre_min_distance
            IConditions.Earth.vInitpq = IConditions.Earth.vInitpq + 2*addv; 
            addv = addv/2;
            min_distance = -10^6;

        elseif min_distance - pre_min_distance < tor/1000
            disp("no Solution");
            break;


        end
        IConditions.Earth.vInitpq = IConditions.Earth.vInitpq - addv;
    else
        break;
    end



    IConditions     =   EparkOrb ( IConditions );
    
    lunar_posInit                   =   [388000,0,0]';
    r0 = IConditions.Earth.r0;
    v0 = IConditions.Earth.v_init;
    pre_min_distance = min_distance;
    [Trans_orb,Lunar_orb_trans, min_distance] = orbitRK89([r0;v0],IConditions,lunar_posInit,"transfer");
    
end