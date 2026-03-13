clear; clc; close all;

%% ===============================
% LOAD DATA
%% ===============================
dataStruct = load('emg_signal_arm_final_v (1).mat');
emg = dataStruct.raw_v_store(:);   % Ensure column vector

%% ===============================
% PARAMETERS

fs = 1000;             
N  = length(emg);
t  = (0:N-1)/fs;

%% ===============================
% DC OFFSET REMOVAL
%% ===============================
emg_dc = emg - mean(emg);

%% ===============================
% FFT ANALYSIS (BEFORE FILTERING)
%% ===============================
EMG_FFT = fft(emg_dc);
f = (0:N-1)*(fs/N);

magFFT = abs(EMG_FFT)/N;

figure;
plot(f(1:N/2), magFFT(1:N/2))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('FFT of Raw EMG')
grid on

%% ===============================
% BANDPASS FILTER (20–450 Hz)
%% ===============================
[b,a] = butter(4, [20 450]/(fs/2), 'bandpass');
emg_filt = filtfilt(b, a, emg_dc);

%% ===============================
% RECTIFICATION
%% ===============================
emg_rect = abs(emg_filt);

%% ===============================
% RMS ENVELOPE (50 ms)
%% ===============================
win = round(0.05 * fs);        % 50 ms window
emg_env = sqrt(movmean(emg_rect.^2, win));

%% ===============================
% NORMALIZATION (Recommended)
%% ===============================
% Option 1: Normalize to maximum voluntary contraction (MVC)
emg_env_norm = emg_env / max(emg_env);

% Option 2 (alternative): Z-score normalization
% emg_env_norm = (emg_env - mean(emg_env)) / std(emg_env);

%% ===============================
% VISUALIZATION
%% ===============================
figure;

subplot(5,1,1)
plot(t, emg)
title('Raw EMG')
ylabel('Amplitude')
grid on

subplot(5,1,2)
plot(t, emg_filt)
title('Band-Passed EMG (20–450 Hz)')
ylabel('Voltage')
grid on

subplot(5,1,3)
plot(t, emg_rect)
title('Rectified EMG')
ylabel('Voltage')
grid on

subplot(5,1,4)
plot(t, emg_env)
title('RMS Envelope (50 ms)')
ylabel('Amplitude')
grid on

subplot(5,1,5)
plot(t, emg_env_norm)
title('Normalized EMG Envelope')
xlabel('Time (s)')
ylabel('Normalized Amplitude')
grid on
%% ===============================
% SAVE NORMALIZED DATA
%% ===============================
save('normalized_emg_env', 'emg_env_norm');
