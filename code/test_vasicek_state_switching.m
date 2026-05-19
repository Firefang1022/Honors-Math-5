% will call the state switching function to test
num_paths = 1000;
T = 30;
dt = 0.1;

[r_paths, t] = Vasicek_State_Switching(num_paths, T, dt);

% Plot 
figure;

% Plot 30 random paths
random_idx = randperm(num_paths, 30);
plot(t, r_paths(random_idx,:), 'Color', [0.6 0.75 1], 'LineWidth', 0.8);
hold on;

% Avg path
plot(t, mean(r_paths), 'b-', 'LineWidth', 3);

% Long-run average
yline(0.0375, 'r--', 'Long-run Average (3.75%)', 'LineWidth', 2.5);

title('Improved Vasicek State-Switching Function(Longer Regimes)');
xlabel('Time (years)');
ylabel('Interest Rate r(t)');
grid on;
legend('30 Random Paths', 'Average Path', 'Long-run Average', 'Location','best');

