% Purpose: Simulate a pension fund's future under uncertainty, combines 
% stocks, bonds(with state-switching), and liabilities. Calculates the 
% shortfall probability as well.

% load parameters file
run('parameters.m');

% settings
num_paths = 10000; 
T = 30; % 30-year horizon
dt = 0.25; % Time step = 3months (quarterly)
t = 0:dt:T; 

% preallocate
Assets_paths = zeros(num_paths, length(t));
Liabilities_paths = zeros(num_paths, length(t));

% starting values
Assets_paths(:,1) = 1000; % 1 billion in starting assets
Liabilities_paths(:,1) = 800;

% simulation
for i = 1:num_paths
    % call function for bonds (state switching)
    [bond_rates, ~] = Vasicek_State_Switching(1, T, dt); % Simulate 1 path at a time

    for n = 1:length(t)-1
        % Stocks (GBM)
        dStocks = mu_stock * Assets_paths(i,n)*dt + ...
            sigma_stock * Assets_paths(i,n)*sqrt(dt)*randn();
        % bonds (use interest rate from the state switching function)
        dBonds = bond_rates(n) * dt; %interest earned

        % Update Assets (60% stocks, 40% bonds)
        Assets_paths(i, n+1) = Assets_paths(i,n) + 0.6 * dStocks + ...
            0.4 * dBonds * Assets_paths(i,n);
        % update liabilities
        Liabilities_paths(i, n+1) = Liabilities_paths(i,n) * (1 + inflation_rate * dt);
    end    
end

% progress check
disp('Simulation Complete...')

% results
final_assets = Assets_paths(:,end);
final_liab = Liabilities_paths(:,end);

shortfall_prob = mean(final_assets < final_liab) * 100;
median_ratio = median(final_assets ./ final_liab);

%print results
fprintf('Results:\n');
disp(['Shortfall Probability: ', num2str(shortfall_prob,4), '%']);
disp(['Median Funding Ratio: ', num2str(median_ratio,4)]);

% Plot 
figure;
subplot(2,2,1)
plot(t, Assets_paths(1:100,:), 'b', 'LineWidth', 0.6);
title('Sample Asset Paths');
xlabel('Time (years)'); 
ylabel('Assets ($ millions)');

subplot(2,2,2)
histogram(final_assets ./ final_liab, 60);
title('Final Funding Ratio Distribution');
xlabel('Assets / Liabilities');
ylabel('Frequency');

subplot(2,2,3)
plot(t, mean(Assets_paths), 'b-', 'LineWidth', 2);
hold on;
plot(t, mean(Liabilities_paths), 'r-', 'LineWidth', 2);
title('Average Assets vs Average Liabilities');
xlabel('Time (years)');
ylabel('Value ($ millions)');
legend('Assets', 'Liabilities');

subplot(2,2,4)
bar([shortfall_prob, 100-shortfall_prob]);
title(['Shortfall Probability = ', num2str(shortfall_prob,3), '%']);
ylabel('Percentage');
xticklabels({'Shortfall', 'No Shortfall'});
