clear; clc; close all;

% Parameters
wn = 5;                          % natural frequency
zeta_values = [0.2 0.8 1.2];     % damping ratios

% Time vector for plotting
t = 0:0.01:5;

% Create figure
figure;
hold on;
grid on;

% Store results
results = [];

for i = 1:length(zeta_values)
    zeta = zeta_values(i);

    % Transfer function G(s) = wn^2 / (s^2 + 2*zeta*wn*s + wn^2)
    num = wn^2;
    den = [1 2*zeta*wn wn^2];
    sys = tf(num, den);

    % Step response
    [y, t_out] = step(sys, t);
    plot(t_out, y, 'LineWidth', 1.5);

    % Step info
    info = stepinfo(sys);

    % Save results
    results = [results;
               zeta, info.RiseTime, info.SettlingTime, ...
               info.Overshoot, info.Peak];
end

legend('\zeta = 0.2', '\zeta = 0.8', '\zeta = 1.2', 'Location', 'best');
xlabel('Time [s]');
ylabel('Output');
title('Step Response of Second-Order Systems');

% Show results table
results_table = array2table(results, ...
    'VariableNames', {'Zeta', 'RiseTime_s', 'SettlingTime_s', 'Overshoot_percent', 'PeakValue'});

disp(results_table);