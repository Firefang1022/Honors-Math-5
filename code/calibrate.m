% Purpose: clean data, calculate exact parameters with real data

%read CSV files
sp500 = readtable('data/SP500.csv');
fedfunds = readtable('data/FEDFUNDS.csv');
cpi = readtable('data/CPIAUCSL.csv');
vix = readtable('data/VIXCLS.csv');
dgs10 = readtable('data/DGS10.csv');

% progress check
disp('All data files loaded');

% clean values:
% For S&P 500 - keep only rows with valid close price
sp500 = sp500(~isnan(sp500.SP500), :);

% remove rows with NaN in main column
fedfunds = fedfunds(~isnan(fedfunds.FEDFUNDS), :);
cpi = cpi(~isnan(cpi.CPIAUCSL), :);
vix = vix(~isnan(vix.VIXCLS), :);
dgs10 = dgs10(~isnan(dgs10.DGS10), :);

% double check 
disp('After cleaning:');
disp(['S&P 500 rows: ', num2str(height(sp500))]);
disp(['FEDFUNDS rows: ', num2str(height(fedfunds))]);

% calculating calibrated parameters
% Stocks (S&P 500)
daily_returns = diff(sp500.SP500) ./ sp500.SP500(1:end-1);
mu_stock = mean(daily_returns) * 252; % Annualized return (assuming 252 trading days/yr)
sigma_stock = std(daily_returns) * sqrt(252); % Annualized volatility

% theta - Long-run interest rate
theta = mean(dgs10.DGS10(end-200:end)) / 100; % Recent 10-year yields

% Inflation/liability growth rate
cpi_returns = diff(cpi.CPIAUCSL) ./ cpi.CPIAUCSL(1:end-1);
inflation_rate = mean(cpi_returns) * 12; % annualized

% Volatility
vix_avg = mean(vix.VIXCLS);
sigma_high = (vix_avg / 100) * 0.65; % rough scaling


disp('FINAL CALIBRATED PARAMETERS');
disp(['mu_stock (Equity Return): ', num2str(mu_stock*100, 4), '%']);
disp(['sigma_stock (Volatility): ', num2str(sigma_stock*100, 4), '%']);
disp(['theta (Long-run Rate): ', num2str(theta*100, 4), '%']);
disp(['Inflation Rate: ', num2str(inflation_rate*100, 4), '%']);
disp(['Suggested sigma_high: ', num2str(sigma_high*100, 4), '%']);
