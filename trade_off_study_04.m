clear; clc; close all;

% -----------------------------------
% 1) Design space
% -----------------------------------
wn_values = [2 3 4 5 6 7];
zeta_values = [0.3 0.5 0.7 0.9 1.1];

% -----------------------------------
% 2) Requirements
% -----------------------------------
req_overshoot_max = 10;     % percent
req_settling_max  = 2.0;    % seconds
req_ss_error_max  = 0.02;   % absolute error

% -----------------------------------
% 3) Storage
% -----------------------------------
results = [];
systems = {};
labels = {};
pass_flags = [];

% Common time vector
t = 0:0.01:5;

% -----------------------------------
% 4) Sweep all candidates
% -----------------------------------
for i = 1:length(wn_values)
    for j = 1:length(zeta_values)

        wn = wn_values(i);
        zeta = zeta_values(j);

        % Build transfer function
        num = wn^2;
        den = [1 2*zeta*wn wn^2];
        sys = tf(num, den);

        % Step response
        [y, t_out] = step(sys, t);

        % Metrics
        info = stepinfo(sys);
        rise_time = info.RiseTime;
        settling_time = info.SettlingTime;
        overshoot = info.Overshoot;
        peak_value = info.Peak;

        % Steady-state error
        y_final = y(end);
        ss_error = abs(1 - y_final);

        % Requirement checks
        pass_overshoot = overshoot < req_overshoot_max;
        pass_settling  = settling_time < req_settling_max;
        pass_ss_error  = ss_error < req_ss_error_max;
        overall_pass   = pass_overshoot && pass_settling && pass_ss_error;

        % Save numeric results
        results = [results;
            wn, zeta, rise_time, settling_time, overshoot, peak_value, ...
            ss_error, pass_overshoot, pass_settling, pass_ss_error, overall_pass];

        % Save systems and labels for plotting
        systems{end+1} = sys;
        labels{end+1} = sprintf('\\omega_n = %.1f, \\zeta = %.1f', wn, zeta);
        pass_flags(end+1) = overall_pass;
    end
end

% -----------------------------------
% 5) Convert to table
% -----------------------------------
results_table = array2table(results, ...
    'VariableNames', {'wn', 'zeta', 'RiseTime_s', 'SettlingTime_s', ...
    'Overshoot_percent', 'PeakValue', 'SS_Error', ...
    'Pass_Overshoot', 'Pass_Settling', 'Pass_SS_Error', 'Overall_Pass'});

% -----------------------------------
% 6) Show full results in popup table
% -----------------------------------
fig_table = figure('Name', 'Trade-Off Study Results', ...
                   'NumberTitle', 'off', ...
                   'Position', [100 100 1100 500]);

uitable(fig_table, ...
    'Data', table2cell(results_table), ...
    'ColumnName', results_table.Properties.VariableNames, ...
    'Units', 'normalized', ...
    'Position', [0 0 1 1]);

% -----------------------------------
% 7) Filter passing designs
% -----------------------------------
passing_designs = results_table(results_table.Overall_Pass == 1, :);

% -----------------------------------
% 8) Choose best design
% Rule: among passing designs, pick smallest settling time
% -----------------------------------
best_design = [];
best_sys = [];

if ~isempty(passing_designs)
    [~, idx_best] = min(passing_designs.SettlingTime_s);
    best_design = passing_designs(idx_best, :);

    % Find corresponding system
    for k = 1:length(systems)
        if results_table.wn(k) == best_design.wn && results_table.zeta(k) == best_design.zeta
            best_sys = systems{k};
            break;
        end
    end
end

% -----------------------------------
% 9) Plot all step responses in one chart
% -----------------------------------
fig_plot = figure('Name', 'All Step Responses', ...
                  'NumberTitle', 'off', ...
                  'Position', [150 150 1100 650]);

hold on;
grid on;

for k = 1:length(systems)
    [y_plot, t_plot] = step(systems{k}, t);

    if pass_flags(k)
        plot(t_plot, y_plot, 'LineWidth', 1.3);
    else
        plot(t_plot, y_plot, '--', 'LineWidth', 1.0);
    end
end

% Highlight best design if it exists
if ~isempty(best_sys)
    [y_best, t_best] = step(best_sys, t);
    plot(t_best, y_best, 'k', 'LineWidth', 3);
end

xlabel('Time [s]');
ylabel('Output');
title('Step Responses of All Candidate Designs');

% Add reference line at final value = 1
yline(1, ':', 'Final Value = 1');

legend_entries = labels;
if ~isempty(best_sys)
    legend_entries{end+1} = 'Best Design';
end

legend(legend_entries, 'Location', 'eastoutside');

% -----------------------------------
% 10) Optional popup for passing designs only
% -----------------------------------
if ~isempty(passing_designs)
    fig_pass = figure('Name', 'Passing Designs Only', ...
                      'NumberTitle', 'off', ...
                      'Position', [200 200 900 300]);

    uitable(fig_pass, ...
        'Data', table2cell(passing_designs), ...
        'ColumnName', passing_designs.Properties.VariableNames, ...
        'Units', 'normalized', ...
        'Position', [0 0 1 1]);
end

% -----------------------------------
% 11) Optional popup for best design only
% -----------------------------------
if ~isempty(best_design)
    fig_best = figure('Name', 'Best Design', ...
                      'NumberTitle', 'off', ...
                      'Position', [250 250 700 120]);

    uitable(fig_best, ...
        'Data', table2cell(best_design), ...
        'ColumnName', best_design.Properties.VariableNames, ...
        'Units', 'normalized', ...
        'Position', [0 0 1 1]);

    fprintf('Best design found: wn = %.2f, zeta = %.2f\n', best_design.wn, best_design.zeta);
else
    fprintf('No design satisfies all requirements.\n');
end 
