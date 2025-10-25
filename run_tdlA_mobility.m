% run_tdlA_mobility.m
% DAT610 - 5G Numerology Project
% Said - TDL-A + Mobility study
%
% Scenarios:
%   SCS = [15 30 60] kHz
%   Channel = TDL-A
%   SNR = -5:2:30 dB
%   Mobility = [0, 120] km/h
%   HARQ = off


clear; clc;
if exist('common_config.m','file'), common_config; end  



%% Config
scs_khz   = [15 30 60];  % subcarrier spacings (kHz)
snr_db    = -5:2:30;     % SNR sweep (dB) from -5 to 30 step 2
speeds    = [0 120];     % user speeds to test (km/h)
harq_on   = false;       % HARQ disabled 
chan_name = 'TDL-A';     % channel label

% SNR penalties per spec/hint
penalty_tdla_db    = 2.0;      % TDL-A vs AWGN
penalty_120kmh_db  = 1.0;      % extra at 120 km/h

% BLER (AWGN) base sigmoid per SCS:
%   BLER_awgn = 1 / (1 + exp(a * (SNR - b_scs)))
a_slope = 0.8;                 
b_mid   = struct('k15', 7.0, 'k30', 7.5, 'k60', 8.0); 

% small SCS implementation penalty

scs_penalty = @(scs) (scs==30)*0.3 + (scs==60)*0.6;

% Throughput model factor 
impl_loss = 0.75;

% I/O
out_dir_results = 'results';
out_dir_figs    = fullfile('figs');
if ~exist(out_dir_results,'dir'), mkdir(out_dir_results); end
if ~exist(out_dir_figs,'dir'), mkdir(out_dir_figs); end

%% Helper lambdas 
sigmoid_bler = @(snr,b) 1 ./ (1 + exp(a_slope * (snr - b)));
se_bpsHz     = @(snr_eff) impl_loss .* log2(1 + 10.^(snr_eff/10));
b_for_scs    = @(scs) (scs==15)*b_mid.k15 + (scs==30)*b_mid.k30 + (scs==60)*b_mid.k60 ...
                      + (~ismember(scs,[15,30,60]))*b_mid.k30;

%% Sweep
% Columns: [scs_khz, speed_kmh, snr_db, bler, thr_bpsHz, latency_ms (NaN), harq_on(0/1)]
rows = [];
for scs = scs_khz
    b0 = b_for_scs(scs);                       % AWGN midpoint for BLER curve
    scs_pen = scs_penalty(scs);                % optional impl penalty
    for v = speeds
        % Effective SNR after penalties
        snr_eff = snr_db - penalty_tdla_db - (v>=120)*penalty_120kmh_db - scs_pen;

        % BLER using shifted SNR against AWGN-like sigmoid
        bler = sigmoid_bler(snr_eff, b0);

        % Clip BLER into [1e-4, 1] for numerical niceness
        bler = min(max(bler, 1e-4), 1);

        % Throughput in bps/Hz using effective SNR and (1-BLER)
        thr  = (1 - bler) .* se_bpsHz(snr_eff);

        % Placeholder latency 
        lat_ms = nan(size(thr));

        % Accumulate
        rows = [rows;
            [repmat(scs, numel(snr_db), 1), ...
             repmat(v,   numel(snr_db), 1), ...
             snr_db(:), bler(:), thr(:), lat_ms(:), repmat(double(harq_on), numel(snr_db), 1)]];
    end
end

% Pack results as table for clarity
results_tbl = array2table(rows, 'VariableNames', ...
    {'scs_khz','speed_kmh','snr_db','bler','thr_bpsHz','latency_ms','harq_on'});

%% Save CSV 
csv_path = fullfile(out_dir_results, 'tdla_mobility.csv');
if exist('utils_write_results_csv.m','file')
    try
        utils_write_results_csv(csv_path, results_tbl);
    catch
        warning('utils_write_results_csv failed; falling back to writetable.');
        writetable(results_tbl, csv_path);
    end
else
    writetable(results_tbl, csv_path);
end
fprintf('Saved results -> %s\n', csv_path);

%% Plotting
% Fig S1: BLER vs SNR (TDL-A, 0 km/h) for SCS 15/30/60
% Fig S2: BLER vs SNR (TDL-A, 120 km/h) for SCS 15/30/60
% Fig S3: Throughput vs SNR (TDL-A, 0 vs 120 km/h) at SCS = 30 kHz

use_utils_plotter = exist('utils_plot_bler_thr_lat.m','file') == 2;

if use_utils_plotter
    try
        utils_plot_bler_thr_lat(results_tbl, 'TDL-A (0 vs 120 km/h)', fullfile(out_dir_figs, 'tdla_mobility'));
    catch
        warning('utils_plot_bler_thr_lat failed; falling back to local plotting.');
        use_utils_plotter = false;
    end
end

if ~use_utils_plotter
    % -------- Fig S1 --------
    figure('Name','Fig S1 - BLER vs SNR (TDL-A, 0 km/h)');
    hold on; grid on; box on;
    for scs = scs_khz
        sel = results_tbl.speed_kmh==0 & results_tbl.scs_khz==scs;
        plot(results_tbl.snr_db(sel), results_tbl.bler(sel), '-o','DisplayName',sprintf('%d kHz',scs));
    end
    xlabel('SNR (dB)'); ylabel('BLER');
    title('Fig S1: BLER vs SNR (TDL-A, 0 km/h)');
    legend('Location','southwest');
    ylim([1e-4 1]); set(gca,'YScale','log');
    saveas(gcf, fullfile(out_dir_figs, 'S1_BLER_TDLA_0kmh.png'));

    % -------- Fig S2 --------
    figure('Name','Fig S2 - BLER vs SNR (TDL-A, 120 km/h)');
    hold on; grid on; box on;
    for scs = scs_khz
        sel = results_tbl.speed_kmh==120 & results_tbl.scs_khz==scs;
        plot(results_tbl.snr_db(sel), results_tbl.bler(sel), '-o','DisplayName',sprintf('%d kHz',scs));
    end
    xlabel('SNR (dB)'); ylabel('BLER');
    title('Fig S2: BLER vs SNR (TDL-A, 120 km/h)');
    legend('Location','southwest');
    ylim([1e-4 1]); set(gca,'YScale','log');
    saveas(gcf, fullfile(out_dir_figs, 'S2_BLER_TDLA_120kmh.png'));

    % -------- Fig S3 --------
    target_scs = 30;
    figure('Name','Fig S3 - Throughput vs SNR (TDL-A, 0 vs 120 km/h) @30 kHz');
    hold on; grid on; box on;
    sel0   = results_tbl.scs_khz==target_scs & results_tbl.speed_kmh==0;
    sel120 = results_tbl.scs_khz==target_scs & results_tbl.speed_kmh==120;
    plot(results_tbl.snr_db(sel0),   results_tbl.thr_bpsHz(sel0),  '-o','DisplayName','0 km/h');
    plot(results_tbl.snr_db(sel120), results_tbl.thr_bpsHz(sel120),'-s','DisplayName','120 km/h');
    xlabel('SNR (dB)'); ylabel('Throughput (bps/Hz)');
    title(sprintf('Fig S3: Throughput vs SNR (TDL-A, 0 vs 120 km/h) @ %d kHz', target_scs));
    legend('Location','southeast');
    saveas(gcf, fullfile(out_dir_figs, 'S3_THR_TDLA_0vs120_30k.png'));
end

fprintf('Generated figures in \"%s\":\n - S1_BLER_TDLA_0kmh.png\n - S2_BLER_TDLA_120kmh.png\n - S3_THR_TDLA_0vs120_30k.png\n', out_dir_figs);
