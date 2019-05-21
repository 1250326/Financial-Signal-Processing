[num,txt]=xlsread('data.xlsx');
[a,b] = size(num);
num = num([1,3:a],:);
num = num(:,1:2:b);
data = num(2:end,:);
data = data(:,1:end-1);
date = txt(3:end,1);
[a,b] = size(data);
data = data';

Y = zeros(b,a);
z = zeros(1,a-13+1);
parfor i = 13:a
   [y, z(i)] = weight_mix(data(:,1:i-1),2,0,1);
   Y(:,i) = y;
end

subplot(2,1,2);
[cap,p,transaction_cost,interest] = capital(Y,data,1e6);
plot(cap);
title('Profit and loss');

subplot(2,1,1);
plot(p);
title('portfolio price');