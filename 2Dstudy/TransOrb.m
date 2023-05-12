function [orb_t,T] = TransOrb(r0,v_init,lunar_posATinj,lunar_SOI,dt)

[orb_t,min_distance,T] = EorbitRK4(dt,[r0,v_init],lunar_posATinj,lunar_SOI);

tor = 0.01;
addv = [0,0.01,0];
pre_level = '+';
while true
    if min_distance > tor
        if pre_level == '-'
            addv = addv/10;
        end
        pre_level = '+';
        v_init = v_init+addv;
        [orb_t,min_distance,T] = EorbitRK4(dt,[r0,v_init],lunar_posATinj,lunar_SOI);
    elseif min_distance < -tor
        if pre_level == '+'
            addv = addv/10;
        end
        pre_level = '-';

        v_init = v_init-addv;
        [orb_t,min_distance,T] = EorbitRK4(dt,[r0,v_init],lunar_posATinj,lunar_SOI);
    else
        break;
    end
end