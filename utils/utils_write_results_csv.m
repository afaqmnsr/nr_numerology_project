function utils_write_results_csv(fname, M)
% columns: [SCS_kHz, SNR_dB, BLER, Throughput_Mbps, Latency_ms, ChannelFlag, SpeedKmh, HARQ, BLER_std, THR_std]
writematrix(M, fname);
end
