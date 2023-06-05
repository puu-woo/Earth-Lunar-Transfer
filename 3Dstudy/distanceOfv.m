v = linspace(10,11,100);

min_distance = zeros(1,length(v));

for i = 1:length(v)
    IConditions.Earth.vInitpq = [0, v(i), 0]';
    IConditions     =   EparkOrb ( IConditions );
    r0 = IConditions.Earth.r0;
    v0 = IConditions.Earth.v_init;
    [~,~, min_distance(i) ] = orbitRK89([r0;v0],IConditions,lunar_posInit);


    
    % Newton Raphson for minimize min distance
end


figure(1)
plot(v,min_distance)

figure(2)

bb = (min_distance(2:end) - min_distance(1:end-1)) / (0.7/100);
bbb = (bb(2:end) - bb(1:end-1)) / (0.04/100);
plot(v(2:end),(min_distance(2:end) - min_distance(1:end-1)) / (0.04/100))
% 
% figure(3)
% plot(v(3:end), bbb)

