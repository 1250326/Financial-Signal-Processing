function A = autocov(k,x)
% calculate lag-n autocovariance of x, return matrix
    [t,T] = size(x);
    x_tau = x;
    m = 1/T*sum(x');
    m = m';
    for i = 1:T
        x_tau(:,i) = x(:,i) - m;
    end
    A = zeros(t,t);
    for i = 1:(T-k)
        A = A + x_tau(:,i)*x_tau(:,i+k)';
    end
    A = A ./ (T-k-1);
end