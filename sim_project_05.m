clear; clc; close all;

simOut = sim('trade_off_study');

y = simOut.yout;
t = simOut.tout;

t = t(:);
y = y(:);

figure;
plot(t, y, 'LineWidth', 1.5);
grid on;
xlabel('Time [s]');
ylabel('Output');
title('Simulink Output Response');

y_final = y(end);
y_peak = max(y);
overshoot = max(0, (y_peak - y_final)/y_final * 100);
ss_error = abs(1 - y_final);

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

req_overshoot_max = 10;
req_settling_max  = 2.0;
req_ss_error_max  = 0.02;

pass_overshoot = overshoot < req_overshoot_max;
pass_settling  = settling_time < req_settling_max;
pass_ss_error  = ss_error < req_ss_error_max;
overall_pass = pass_overshoot && pass_settling && pass_ss_error;

fprintf('--- SIMULINK VALIDATION REPORT ---\n');
fprintf('Final value        = %.4f\n', y_final);
fprintf('Peak value         = %.4f\n', y_peak);
fprintf('Overshoot          = %.2f %%\n', overshoot);
fprintf('Settling time      = %.4f s\n', settling_time);
fprintf('Steady-state error = %.6f\n', ss_error);

fprintf('\n--- REQUIREMENT CHECK ---\n');
fprintf('Overshoot < %.2f %%      --> %s\n', req_overshoot_max, string(pass_overshoot));
fprintf('Settling time < %.2f s  --> %s\n', req_settling_max, string(pass_settling));
fprintf('SS error < %.4f        --> %s\n', req_ss_error_max, string(pass_ss_error));
fprintf('\nOVERALL RESULT --> %s\n', string(overall_pass)); 
