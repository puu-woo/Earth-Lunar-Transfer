%% viewer of the orbvalue and the effetive coeffi
    fg = figure(1);
    fg.Position = [200,70,1280,720];
    for j = 1:9
        subplot(4,2, j);
        plot(x(1:i), orbvalue(1:i, j+1));
        grid on
        grid minor
        
        if j == 1
            title('a');
        end
        if j == 2
            title('ecc');
        end
        if j == 3
            title('inc');
        end
        if j == 4
            title('argper');
        end
        if j == 5
            title('raan');
        end
        if j == 6
            title('f');
        end
        if j == 7
            title('dv1')
        end
        if j == 8
            title('dv2')
        end
      
    end