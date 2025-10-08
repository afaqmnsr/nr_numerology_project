function utils_plot_bler_thr_lat(M, titleTag, outPrefix)
% One figure per metric; groups by SCS (and implicitly by channel/speed/HARQ if you subset)
scsVals = unique(M(:,1));

% BLER
figure; hold on;
for scs = scsVals'
    sel = M(:,1)==scs;
    plot(M(sel,2), M(sel,3), 'DisplayName', sprintf('%dkHz', scs));
end
xlabel('SNR (dB)'); ylabel('BLER'); legend('Location','southwest'); 
title(['BLER - ' titleTag]);
saveas(gcf, [outPrefix '_bler.png']);

% Throughput
figure; hold on;
for scs = scsVals'
    sel = M(:,1)==scs;
    plot(M(sel,2), M(sel,4), 'DisplayName', sprintf('%dkHz', scs));
end
xlabel('SNR (dB)'); ylabel('Throughput (Mb/s)'); legend('Location','southeast');
title(['Throughput - ' titleTag]);
saveas(gcf, [outPrefix '_thr.png']);

% Latency
figure; hold on;
for scs = scsVals'
    sel = M(:,1)==scs;
    plot(M(sel,2), M(sel,5), 'DisplayName', sprintf('%dkHz', scs));
end
xlabel('SNR (dB)'); ylabel('Latency (ms)'); legend('Location','northeast');
title(['Latency - ' titleTag]);
saveas(gcf, [outPrefix '_lat.png']);

% Error bars for throughput if available
if size(M,2) >= 10
    figure; hold on;
    for scs = scsVals'
        sel = M(:,1)==scs;
        x = M(sel,2); y = M(sel,4); e = M(sel,10); % thr_std at col 10
        errorbar(x, y, e, 'DisplayName', sprintf('%dkHz', scs));
    end
    xlabel('SNR (dB)'); ylabel('Throughput (Mb/s)');
    legend('Location','southeast'); title(['Throughput (±1σ) - ' titleTag]);
    saveas(gcf, [outPrefix '_thr_err.png']);
end
end
