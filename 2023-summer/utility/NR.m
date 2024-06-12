function sol = NR(equation, derivative, initValue, tolerance)
%% Solve Equation by Newton Raphson Method

maxiter = 10000000;
x = zeros(maxiter,1);
x(1,1) = initValue;
tol = tolerance;
i = 2;


while true
    f = equation(x(i-1,1));
    df = derivative(x(i-1,1));
    x(i,1) = x(i-1,1) - f/df;
    if abs(f) < tol
        sol = x(i,1);
        break;
    end
    i = i+1;
    if i > maxiter
        disp('Newton Raphson Divergence')
        sol = NaN;
        break;
    end
end

end
