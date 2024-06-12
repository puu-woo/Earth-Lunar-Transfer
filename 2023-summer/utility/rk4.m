function sol = rk4(equation, initValue)
%% Solve Differential Equation by Runge Kutta 4th order

step = 0.000001;
x0 = initValue;
iter = 10000;

x = x0;

for i = 1:iter
    k1 = step * equation(x);
    k2 = step * equation(x + k1/2);
    k3 = step * equation(x + k2/2);
    k4 = step * equation(x + k3/2);

    x = x + (k1 + 2 * k2 + 2 * k3 + k4)/6;
end
sol = x;
end