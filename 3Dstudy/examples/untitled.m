
data = reshape(oev(3,:,:),[10,3]);

% for i = 1:50
%     for j = 1:50
%     
%         if oev(:,i,j) == [0,0,0,0,0,0]'
%             oev(:,i,j) = [NaN,NaN,NaN,NaN,NaN,NaN]';
%         
%         end
% 
%     end
% end

surf(incs*180/pi,raans*180/pi,data*180/pi,'EdgeColor','none')
xlabel("incs")
ylabel("raans")
zlabel("inc")