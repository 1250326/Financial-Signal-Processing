function [arr,p,transaction_cost,interest] = capital(weight,price,initial)
% Simulate the capital flow given daily weight
    asset = initial;
    index = find(max(weight) == 0);
    [n,len] = size(weight);
    price = price(:,1:len);
    num_stock = zeros(n,1);
    transaction_cost = 0;
    arr = zeros(1,len);
    count = 0;
    p = zeros(1,max(index));
    % Tuning parameter
    update_freq = 50;
    buy_sell_threshold = 0.5;
    
    for i = (max(index)+1):len
        if count == 0
            num_stock = asset.*weight(:,i)./price(:,i);
            asset = 0;
            w = weight(:,i);
            num_last = num_stock(:,1);
            count = count + 1;
            continue;
        end

        if mod(i,update_freq) == mod(max(index)+1,update_freq)
            w = weight(:,i);
        end
        
        if count > update_freq
            count = update_freq;
        end

        if (mean(w'*price(:,i-count:i)) - w'*price(:,i)) / std(w'*price(:,i-count:i)) < -buy_sell_threshold && norm(num_stock) ~= 0
            asset = asset + num_stock'*price(:,i); % sell
            num_stock = zeros(n,1);
            transaction_cost = transaction_cost + 2*abs(num_stock-num_last)'*price(:,i)*0.001097 + n;
            num_last = num_stock;
        elseif (mean(w'*price(:,i-count:i)) - w'*price(:,i)) / std(w'*price(:,i-count:i)) > buy_sell_threshold && asset ~= 0
            num_stock = asset.*weight(:,i)./price(:,i); % update inventory
            asset = 0; % buy
            transaction_cost = transaction_cost + 2*abs(num_stock-num_last)'*price(:,i)*0.001097 + n;
            num_last = num_stock;
        end
        
        count = count + 1;
        disp([num2str(i-1),' th day: ',num2str(asset + num_stock'*price(:,i))]);
        
        arr(i) = asset + num_stock'*price(:,i) - initial;
        p(i) = w'*price(:,i);
    end
    interest = (((arr(end)+initial-transaction_cost)-initial)/initial)/(len-max(index))*365;
    disp(['transaction cost: ',num2str(transaction_cost)]);
    disp(['interest: ', num2str(interest)]);
end