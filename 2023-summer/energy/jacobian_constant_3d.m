clear
m_e = 5.9742*10^24;
m_l = 7.36*10^22;
mu = m_l / (m_e+m_l);


[x,y,z] = meshgrid(linspace(-1.5,1.5,70));
p = (x.^2+y.^2) + 2*(1-mu)./sqrt((x+mu).^2+y.^2+z.^2) + 2 * mu ./sqrt((x-1+mu).^2+y.^2);
% JC = linspace(2.98,3.1,10);
JC = 3.19;


figure
view(3)
for i = 1:length(JC)

    s = isosurface(x,y,z,p,JC(i));
    pat = patch(s);
    pat.FaceColor = [0.4,0.4,0.4];
    pat.FaceAlpha = 0.8;
    pat.EdgeColor = 'none';

    hold on
    plot(-mu,0,'Marker','.','MarkerSize',40,'Visible','off')
    plot(1-mu,0,'Marker','.','MarkerSize',10,'Visible','off')
    hold off

    title("Jacobi Constant = "+num2str(JC(i)))
    legend(pat,'Zero Velocity Curve (ZVC)',Location='best')
    grid on
    drawnow
    
end