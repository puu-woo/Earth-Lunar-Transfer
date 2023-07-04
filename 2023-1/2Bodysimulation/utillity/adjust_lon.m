function [lon_Erot_adj] = adjust_lon(lon_Erot)

lon_Erot_adj = lon_Erot;

while any(lon_Erot_adj > 360)
    idx = find(lon_Erot_adj > 360); 
    for i = 1:length(idx)
        if lon_Erot_adj(idx(i)) > 360
            lon_Erot_adj(idx(i)) = lon_Erot_adj(idx(i)) - 360;
        end
    end
end
