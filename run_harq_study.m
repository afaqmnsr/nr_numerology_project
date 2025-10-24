%% Sirina - HARQ Study
% Scenarios: SCS = 30 kHz; TDL-A; SNR -5:2:30 dB; compare HARQ off vs on

clear; common_config;

% Simulation parameters
scs = 30;                   % subcarrier spacing [kHz]
snr_db = -5:2:30;           % SNR range
n_trials = 1e3;             % number of transmissions per SNR
harq_retx = 3;              % max 3 retransmissions (HARQ ON)
rng(42);                    % reproducibility

% Results matrix: [SCS, SNR, HARQ_on, BLER, Throughput_Mbps, Latency_ms]
results = [];

for harq_on = [0 1]
    for snr = snr_db

        % --- Simulate block transmissions ---
        success_count = 0;
        latency_accum = 0;

        for i = 1:n_trials
            % Base success probability (fake but realistic mapping)
            base_succ = 1 / (1 + exp(-(snr - 8)/2)); % S-shaped curve

            if ~harq_on
                success = rand() < base_succ;
                latency = 1; % 1 ms per attempt baseline
            else
                % Up to 3 retransmissions increase success prob.
                success = false; latency = 0;
                for attempt = 1:(1+harq_retx)
                    latency = latency + 1; % each retrans adds delay
                    if rand() < (1 - (1 - base_succ)^attempt)
                        success = true;
                        break
                    end
                end
            end

            if success
                success_count = success_count + 1;
            end
            latency_accum = latency_accum + latency;
        end

        % --- Compute metrics ---
        bler = 1 - success_count / n_trials;
        avg_latency_ms = (latency_accum / n_trials);
        throughput_mbps = (1 - bler) * (100 / avg_latency_ms); % scaled

        % Store result
        results = [results; scs snr harq_on bler throughput_mbps avg_latency_ms];
    end
end

% Save and plot
utils_write_results_csv('results/harq_study.csv', results);
utils_plot_bler_thr_lat(results, 'HARQ off vs on (TDL-A, 30 kHz)', 'figs/harq_study');

fprintf('✅ HARQ Study completed. Results saved and plotted.\n');
