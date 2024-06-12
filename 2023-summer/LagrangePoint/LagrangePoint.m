function LPoint = LagrangePoint(IConditions)
%% Find equilibrium solution for Lagrange Point
format long
LPoint = zeros(5,3);

% Constants
%mu = IConditions.mu;
mu = 0.01215046329;
%G = 6.67e-11;

% Euler Point: the Equilibrium solution is on the x axis (y=z=0)
eq1     =   @(x) x +(1-mu)/(x+mu)^2 + mu/(x-1+mu)^2;
deq1    =   @(x) 1-2*(1-mu)/(x+mu)^3 - 2*mu/(x-1+mu)^3;
eq2     =   @(x) x-(1-mu)/(x+mu)^2 + mu/(x-1+mu)^2;
deq2    =   @(x) 1+2*(1-mu)/(x+mu)^3 - 2*mu/(x-1+mu)^3;
eq3     =   @(x) x-(1-mu)/(x+mu)^2 - mu/(x-1+mu)^2;
deq3    =   @(x) 1+2*(1-mu)/(x+mu)^3 + 2*mu/(x-1+mu)^3;
% Newton-Raphson Method
LPoint(1,1) = NR(eq1,deq1,-1,1e-10);
LPoint(2,1) = NR(eq2,deq2,1.15568,1e-10);
LPoint(3,1) = NR(eq3,deq3,-1,1e-10);


% Lagrange Point: y!=0
LPoint(4,1) = 1/2 - mu;
LPoint(4,2) = sqrt(3)/2;
LPoint(5,1) = 1/2 - mu;
LPoint(5,2) = -sqrt(3)/2;

end