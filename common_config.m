% Shared constants for 5G Numerology project
cfg.SNRdB = -5:2:30;
cfg.SCSList = [15 30 60]; % kHz
cfg.BW = 20e6; % 20 MHz
cfg.Carrier = 3.5e9; % 3.5 GHz
cfg.TBbits = 8448; % example TB size (adjust if needed)
cfg.Ntrials = 250; % TBs per SNR point (tune for runtime)
cfg.Seeds = [11 22 33]; % for Afaq's error bars
rng(12345);
