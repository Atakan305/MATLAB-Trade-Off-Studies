clear; clc; close all;

% -----------------------------
% 1) Define candidate system
% -----------------------------
wn = 4.5;
zeta = 0.60;

num = wn^2;
den = [1 2*zeta*wn wn^2];
sys = tf(num, den);

% -----------------------------
% 2) Step response
% -----------------------------
t = 0:0.01:5;
[y, t_out] = step(sys, t);

figure;
plot(t_out, y, 'LineWidth', 1.5);
grid on;
xlabel('Time [s]');
ylabel('Output');
title('Step Response for Validation Check');

% -----------------------------
% 3) Extract metrics
% -----------------------------
info = stepinfo(sys);
overshoot = info.Overshoot;
settling_time = info.SettlingTime;

% -----------------------------
% 4) Steady-state error
% -----------------------------
y_final = y(end);
ss_error = abs(1 - y_final);

% -----------------------------
% 5) Requirements
% -----------------------------
req_overshoot_max = 10;     % percent
req_settling_max  = 2.0;    % seconds
req_ss_error_max  = 0.02;   % absolute error

pass_overshoot = overshoot < req_overshoot_max;
pass_settling  = settling_time < req_settling_max;
pass_ss_error  = ss_error < req_ss_error_max;

overall_pass = pass_overshoot && pass_settling && pass_ss_error;

% -----------------------------
% 6) Print results
% -----------------------------
fprintf('--- SYSTEM VALIDATION REPORT ---\n');
fprintf('Overshoot        = %.2f %%\n', overshoot);
fprintf('Settling Time    = %.2f s\n', settling_time);
fprintf('Steady-state err = %.4f\n', ss_error);

fprintf('\n--- REQUIREMENT CHECK ---\n');
fprintf('Overshoot < %.2f %%        --> %s\n', req_overshoot_max, string(pass_overshoot));
fprintf('Settling Time < %.2f s    --> %s\n', req_settling_max, string(pass_settling));
fprintf('SS Error < %.4f          --> %s\n', req_ss_error_max, string(pass_ss_error));

fprintf('\nOVERALL RESULT --> %s\n', string(overall_pass)); 

