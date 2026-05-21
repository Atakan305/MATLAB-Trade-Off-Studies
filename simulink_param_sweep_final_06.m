clear; clc; close all;

% -----------------------------------
% 1) Design space
% -----------------------------------
K_values    = [1 2 5];
wn_values   = [3 5 7];
zeta_values = [0.3 0.7 1.0];

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
all_responses = {};
all_labels = {};
pass_flags = [];

% -----------------------------------
% 4) Sweep
% -----------------------------------
case_id = 0;

for i = 1:length(K_values)
    for j = 1:length(wn_values)
        for k = 1:length(zeta_values)

            case_id = case_id + 1;

            K = K_values(i);
            wn = wn_values(j);
            zeta = zeta_values(k);

            % Push variables to base workspace for Simulink
            assignin('base', 'K', K);
            assignin('base', 'wn', wn);
            assignin('base', 'zeta', zeta);

            % Run simulation
            simOut = sim('trade_off_study');

            % Read output
            y = simOut.yout;
            t = simOut.tout;

            y = y(:);
            t = t(:);

            % Metrics
            y_final = y(end);
            y_peak = max(y);

            if abs(y_final) < 1e-12
                overshoot = NaN;
            else
                overshoot = max(0, (y_peak - y_final)/abs(y_final) * 100);
            end

            ss_error = abs(1 - y_final);

            % Settling time (2% band around final value)
            band = 0.02 * abs(y_final);
            idx_outside = find(abs(y - y_final) > band);

            if isempty(idx_outside)
                settling_time = 0;
            else
                last_outside = idx_outside(end);
                if last_outside < length(t)
                    settling_time = t(last_outside + 1);
                else
                    settling_time = t(end);
                end
            end

            % Requirement checks
            pass_overshoot = overshoot < req_overshoot_max;
            pass_settling  = settling_time < req_settling_max;
            pass_ss_error  = ss_error < req_ss_error_max;
            overall_pass   = pass_overshoot && pass_settling && pass_ss_error;

            % Save numeric results
            results = [results;
                case_id, K, wn, zeta, y_final, y_peak, overshoot, ...
                settling_time, ss_error, ...
                pass_overshoot, pass_settling, pass_ss_error, overall_pass];

            % Save response for plotting
            all_responses{end+1} = struct('t', t, 'y', y);
            all_labels{end+1} = sprintf('K=%.1f, wn=%.1f, zeta=%.1f', K, wn, zeta);
            pass_flags(end+1) = overall_pass;
        end
    end
end

% -----------------------------------
% 5) Convert to table
% -----------------------------------
results_table = array2table(results, ...
    'VariableNames', {'CaseID','K','wn','zeta','FinalValue','PeakValue', ...
    'Overshoot_percent','SettlingTime_s','SS_Error', ...
    'Pass_Overshoot','Pass_Settling','Pass_SS_Error','Overall_Pass'});

disp(results_table);

% -----------------------------------
% 6) Popup table
% -----------------------------------
fig_table = figure('Name', 'Simulink Parameter Sweep Results', ...
                   'NumberTitle', 'off', ...
                   'Position', [100 100 1200 500]);

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
% 8) Best design selection
% Rule: choose passing design with minimum settling time
% -----------------------------------
if ~isempty(passing_designs)
    [~, idx_best] = min(passing_designs.SettlingTime_s);
    best_design = passing_designs(idx_best, :);

    fprintf('\n--- BEST DESIGN ---\n');
    disp(best_design);
else
    best_design = [];
    fprintf('\nNo design satisfies all requirements.\n');
end

% -----------------------------------
% 9) Plot all responses
% -----------------------------------
fig_plot = figure('Name', 'All Simulink Responses', ...
                  'NumberTitle', 'off', ...
                  'Position', [150 150 1100 650]);

hold on; grid on;

for n = 1:length(all_responses)
    t = all_responses{n}.t;
    y = all_responses{n}.y;

    if pass_flags(n)
        plot(t, y, 'LineWidth', 1.2);
    else
        plot(t, y, '--', 'LineWidth', 1.0);
    end
end

yline(1, ':', 'Reference = 1');
xlabel('Time [s]');
ylabel('Output');
title('All Simulink Responses for Parameter Sweep');
legend(all_labels, 'Location', 'eastoutside');

% The Simulink parameter sweep ran successfully and revealed that none of 
% the tested proportional-only controller configurations satisfied all 
% performance requirements simultaneously. The dominant failure mechanism 
% was steady-state error, since the closed-loop output converged below the 
% unit reference for all tested gains. This indicates that the current 
% controller structure is too limited to achieve zero or near-zero tracking error.

% -----------------------------------
% 10) Highlight best design if exists
% -----------------------------------
if ~isempty(best_design)
    % Find matching case
    idx_match = find(results_table.CaseID == best_design.CaseID, 1);
    best_resp = all_responses{idx_match};

    plot(best_resp.t, best_resp.y, 'k', 'LineWidth', 3);

    % Best design popup
    fig_best = figure('Name', 'Best Simulink Design', ...
                      'NumberTitle', 'off', ...
                      'Position', [250 250 800 120]);

    uitable(fig_best, ...
        'Data', table2cell(best_design), ...
        'ColumnName', best_design.Properties.VariableNames, ...
        'Units', 'normalized', ...
        'Position', [0 0 1 1]);
end 

% -----------------------------------
% 11) Save results to a file
% -----------------------------------
writetable(results_table, 'simulation_results.csv'); 
