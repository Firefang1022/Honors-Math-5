% Parameters
mu = 0.07;
S0 = 100;
T  = 30;
dt = 0.1;
t  = 0:dt:T;

% Exact solution (separable equation)
S_exact = S0 * exp(mu * t);

%plot
figure;
plot(t, S_exact, 'b-', 'LineWidth', 2);
title('Deterministic Geometric Brownian Motion (Stock Price Growth)');
xlabel('Time (years)');
ylabel('Stock Price / Index Level');
grid on;
