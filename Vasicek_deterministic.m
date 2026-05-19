% baseline for vasicek
kappa = 0.3;
theta = 0.0375; 
r0 = 0.036;
T = 30;
dt = 0.1; 
t = 0:dt:T;

%Exact solution using integrating factor:
%using the formula: r(t) = theta + (r0 - theta) * exp(-kappa * t)
r_exact = theta + (r0 - theta) * exp(-kappa * t);

%plot solution
figure;
plot(t, r_exact, 'b-', 'LineWidth', 2.5);
hold on;
yline(theta, 'r--', 'Long-run Average (θ)', 'LineWidth', 1.5);

title('Vasicek Interest Rate Model - Deterministic Solution');
xlabel('Time (years)');
ylabel('Interest Rate r(t)');
grid on;
legend('Exact Solution', 'Long-run Mean');

disp('Vasicek deterministic model completed!');