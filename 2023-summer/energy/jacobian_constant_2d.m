clear
m_e = 5.9742*10^24;
m_l = 7.36*10^22;
mu = m_l / (m_e+m_l);


[x,y] = meshgrid(linspace(-2,2,120));
z = (x.^2+y.^2) + 2*(1-mu)./sqrt((x+mu).^2+y.^2) + 2 * mu ./sqrt((x-1+mu).^2+y.^2);
JC = linspace(2.98,3.3,100);


figure
for i = 1:length(JC)
    contourf(x,y,-z,'LevelList',-JC(i),'FaceColor',[0.4,0.4,0.4])
    hold on
    plot(-mu,0,'Marker','.','MarkerSize',40)
    plot(1-mu,0,'Marker','.','MarkerSize',10)
    hold off
    title("Jacobi Constant = "+num2str(JC(i)))
    grid on
    drawnow
    
end