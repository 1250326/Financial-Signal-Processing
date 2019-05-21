function [y, exitf] = weight_mix(matrix,f1,f2,f3)
% Calculate weight of portfolio at time t, given data at time t.
% Needed 10 days data
    [r,c] = size(matrix);
    
    % tuning parameters
    v = 0.7;
    mu = 1;
    rho = 100;

    y0 = 1/r.*ones(r,1);
    A0 = autocov(0,matrix);
    A1 = autocov(1,matrix);
    A2 = autocov(2,matrix);
    A3 = autocov(3,matrix);
    A4 = autocov(4,matrix);
    A5 = autocov(5,matrix);
    A6 = autocov(6,matrix);
    A7 = autocov(7,matrix);
    A8 = autocov(8,matrix);
    A9 = autocov(9,matrix);
    A10 = autocov(10,matrix);
    M = A1*inv((A0+1e-6*eye(r)))*A1';
    
    fun = @(y) f1*(y'*M*y) + f2 * (y'*A1*y)^2 + (f2 + mu*f3)*((y'*A2*y)^2 + (y'*A3*y)^2 + (y'*A4*y)^2 + (y'*A5*y)^2 + (y'*A6*y)^2 + (y'*A7*y)^2 + (y'*A8*y)^2 + (y'*A9*y)^2 + (y'*A10*y)^2) + f3 * y'*A1*y + rho * length(find(y == 0));
    
    function [c, ceq] = C(y)
        c = v - y'*A0*y;
        ceq = norm(y,1) - 1;
    end

    options=optimset('display','off','Algorithm','sqp');
    [y,fval,exitf] = fmincon(fun,y0,[],[],[],[],zeros(r,1),ones(r,1),@C,options);
    disp(exitf);
end
