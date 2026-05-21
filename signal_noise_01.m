clear; clc; close all;

% 1) Time vector
fs = 100;                  % sampling frequency [Hz]
T = 10;                    % total duration [s]
t = 0:1/fs:T;

% 2) Clean signal
x_clean = sin(2*pi*0.5*t) + 0.3*sin(2*pi*3*t);

% 3) Add noise
noise = 0.4*randn(size(t));
x_noisy = x_clean + noise;

% 4) Moving average filtering
x_filt_5  = movmean(x_noisy, 5);
x_filt_15 = movmean(x_noisy, 15);
x_filt_30 = movmean(x_noisy, 30);

% 5) Plot signals
figure;
plot(t, x_clean, 'LineWidth', 1.5); hold on;
plot(t, x_noisy);
plot(t, x_filt_15, 'LineWidth', 1.5);
grid on;
legend('Clean signal', 'Noisy signal', 'Filtered signal (15)');
xlabel('Time [s]');
ylabel('Amplitude');
title('Signal filtering example');

% 6) Root Mean Squared Error (RMSE) calculation
rmse_noisy   = sqrt(mean((x_noisy - x_clean).^2));
rmse_filt_5  = sqrt(mean((x_filt_5 - x_clean).^2));
rmse_filt_15 = sqrt(mean((x_filt_15 - x_clean).^2));
rmse_filt_30 = sqrt(mean((x_filt_30 - x_clean).^2));

fprintf('RMSE noisy      = %.4f\n', rmse_noisy);
fprintf('RMSE filtered 5 = %.4f\n', rmse_filt_5);
fprintf('RMSE filtered15 = %.4f\n', rmse_filt_15);
fprintf('RMSE filtered30 = %.4f\n', rmse_filt_30); 

