%raw calculated values for reference only
mu_stock_raw = 0.1507;
sigma_stock_raw = 0.2058;
theta_raw = 0.04195;
inflation_raw = 0.03472;
suggested_sigmahigh = 0.1248;

% Final justified parameters (used in simulations)
mu_stock = 0.12;      
sigma_stock = 0.2058;
theta = 0.04195;   
sigma_low = 0.010;
sigma_high = 0.022;     
inflation_rate = 0.03472;

% additional parameters for Vasicek model
kappa = 0.3; %mean reversion speed
r0 = 0.036; % initial interest rate of 3.6%