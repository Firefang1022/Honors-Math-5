% Goal: simulate many possible random paths for interest rates

% Load Parameters
run('parameters.m');

constant_sigma = 0.015;
r0 = 0.036; % Starting interest rate
T = 30;
dt = 0.1;
N = round(T / dt);
num_paths = 1000;
t = 0:dt:T;

% preallocation
r_paths = zeros(num_paths, length(t)); 
r_paths(:,1) = r0; % every path has same starting value

%simulation
for i = 1:num_paths                    
    for n = 1:N 

        % Drift - predictable part (will pull rate back toward 3.75%)
        drift = kappa * (theta - r_paths(i,n)) * dt;

        % Diffusion - random unpredictable shock
        diffusion = constant_sigma * sqrt(dt) * randn();

        % Using euler's method - new_rate = old_rate + predictable change + random shock
        r_paths(i, n+1) = r_paths(i,n) + drift + diffusion;
    end
end

%plot
figure;

% plot 30 individual random paths
random_idx = randperm(num_paths, 30);
plot(t, r_paths(random_idx,:), 'Color', [0.7 0.75 0.95], 'LineWidth', 0.7);
hold on;

% Plot the average of all 1000 paths (thick blue line)
plot(t, mean(r_paths), 'b-', 'LineWidth', 3);

% Plot the long-run average as a reference
yline(theta, 'r--', 'Long-run Average (3.75%)', 'LineWidth', 2);

title('Basic Stochastic Vasicek Model (Constant Volatility)');
xlabel('Time (years)');
ylabel('Interest Rate r(t)');
grid on;
legend('30 Individual Random Paths', 'Average of All Paths', 'Long-run Average', 'Location','best');
