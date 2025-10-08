% TODO: Said - TDL-A + Mobility Study
% Scenarios: SCS = 15/30/60; TDL-A; SNR –5:2:30 dB; mobility 0 and 120 km/h; HARQ off
% 
% Expected outputs:
% - Fig S1: BLER vs SNR (TDL-A, 0 km/h) for 15/30/60
% - Fig S2: BLER vs SNR (TDL-A, 120 km/h) for 15/30/60  
% - Fig S3: Throughput vs SNR (TDL-A, 0 vs 120 km/h) at one SCS (e.g., 30 kHz)

clear; common_config;

% TODO: Implement TDL-A + mobility simulation
% Hint: TDL-A is ~2 dB worse than AWGN; 120 km/h adds ~another 1 dB penalty

results = [];
% TODO: Add your simulation code here

% TODO: Save results
% utils_write_results_csv('results/tdla_mobility.csv', results);
% utils_plot_bler_thr_lat(results, 'TDL-A (0 vs 120 km/h)', 'figs/tdla_mobility');

fprintf('TODO: Implement TDL-A + mobility study\n');
