% TODO: Sirina - HARQ Study
% Scenarios: Pick SCS = 30 kHz; TDL-A; SNR –5:2:30 dB; compare HARQ off vs on
%
% Expected outputs:
% - Fig R1: Latency vs SNR (HARQ off/on) — HARQ reduces average and tail latency at mid SNR
% - Fig R2: Throughput vs SNR (HARQ off/on)
% - Fig R3: (nice-to-have) Latency CDF at a mid SNR (e.g., 12 dB), off vs on

clear; common_config;

% TODO: Implement HARQ study
% Hint: HARQ allows up to 3 retransmissions; each attempt increases success probability

results = [];
% TODO: Add your HARQ simulation code here

% TODO: Save results  
% utils_write_results_csv('results/harq_study.csv', results);
% utils_plot_bler_thr_lat(results, 'HARQ off vs on (TDL-A, 30 kHz)', 'figs/harq_study');

fprintf('TODO: Implement HARQ study\n');
