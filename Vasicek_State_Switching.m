%   Vasicek model but has the regime-switch feature
function [r_paths, t] = Vasicek_State_Switching(num_paths, T, dt)

    if nargin < 3
    dt = 0.1;
    end

    % Load Parameters
    run('parameters.m'); %loads theta, sigma_low, sigma_high

    N = round(T/dt); % Total number of time steps (300)
    t = 0:dt:T; % Time vector

    % preallocation for all paths
    r_paths = zeros(num_paths, length(t));
    r_paths(:,1) = r0; % make sure all paths start at current rate
    
    %state switching part (longer regimes):
    regime_length = 40; % Avg length of each regime in steps (~4 years)

    % simulation
    for i = 1:num_paths
        curr_regime = 0;
        current_sigma = sigma_low;
        
        for n = 1:N
            curr_regime = curr_regime + 1;

            if curr_regime > regime_length
                if rand() < 0.5
                    current_sigma = sigma_high;
                else
                    current_sigma = sigma_low;
                end
                curr_regime = 0;
            end
            drift = kappa * (theta - r_paths(i,n)) * dt;
            diffusion = current_sigma * sqrt(dt) * randn();
            r_paths(i, n+1) = r_paths(i,n) + drift + diffusion;
        end
    end
end

