clear; common_config;

% Add utils folder to path
addpath('utils');

results = [];
for scs = cfg.SCSList
    slotsPerMs = containers.Map({15,30,60}, {1,2,4});
    slotDurMs = 1 / slotsPerMs(scs); % 1.00 / 0.50 / 0.25 ms
    
    for snr = cfg.SNRdB
        bler_seeds = zeros(numel(cfg.Seeds),1);
        thr_seeds = zeros(numel(cfg.Seeds),1);
        
        for si = 1:numel(cfg.Seeds)
            rng(cfg.Seeds(si));
            blerCount = 0; nTB = cfg.Ntrials;
            
            for k = 1:nTB
                % bits -> PDSCH tx -> AWGN(snr) -> rx -> decode
                % Placeholder success probability (AWGN baseline)
                tbOK = rand < (1 - 10.^((-(snr-5))/8));
                blerCount = blerCount + (~tbOK);
            end
            
            bler = blerCount / nTB;
            
            % AMC-based throughput approximation:
            BW_Hz = cfg.BW;                      % 20e6
            thr = (BW_Hz * amc_se(snr) / 1e6) * (1 - bler); % Mb/s
            
            bler_seeds(si) = bler; 
            thr_seeds(si) = thr;
        end
        
        bler_mean = mean(bler_seeds); 
        thr_mean = mean(thr_seeds);
        bler_std = std(bler_seeds);
        thr_std = std(thr_seeds);
        
        lat = slotDurMs / max((1-bler_mean), 1e-6);
        
        results = [results; scs, snr, bler_mean, thr_mean, lat, 0, 0, 0, bler_std, thr_std]; %#ok<AGROW>
        % columns: [SCS, SNR, BLER, THR, LAT, Channel(0=AWGN,1=TDL-A), SpeedKmh, HARQ, BLER_std, THR_std]
    end
end

utils_write_results_csv('results/awgn_baseline.csv', results);
utils_plot_bler_thr_lat(results, 'AWGN baseline', 'figs/awgn_baseline');

fprintf('AWGN baseline completed!\n');
fprintf('Generated: results/awgn_baseline.csv and figs/awgn_baseline_*.png\n');

% Simple AMC: map SNR->spectral efficiency (bits/s/Hz) for AWGN
function se = amc_se(snr)
    % piecewise toy curve (tweak later)
    if snr < 0,      se = 0.3;   % QPSK low rate
    elseif snr < 5,  se = 0.8;
    elseif snr <10,  se = 1.6;   % 16-QAM-ish
    elseif snr <15,  se = 2.4;
    elseif snr <20,  se = 3.2;   % 64-QAM-ish
    else             se = 4.0;   % 256-QAM-ish
    end
end
