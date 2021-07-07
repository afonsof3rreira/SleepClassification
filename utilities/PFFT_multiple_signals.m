% FF spectrum of matrix signals as IMFs
function PFFT_multiple_signals(s1, s2, ind_filtered, Fs, fig_name, func_name, signal_label)

sup_str = strcat('Single-Sided Amplitude Spectrum of Mode(t) $|$FFT(f)$|$ using $\,$',...
                 func_name, ': original vs filtered');

fig_str = strcat(fig_name, '-FFT-', func_name);


    
figure('Name', fig_str, 'Position', [353,34,560,663]);

L = size(s2, 2);
T = 1/Fs;                       % Sampling period       
t = (0:L-1)*T;                  % Time vector
f = Fs*(0:(L/2))/L;

for i = 1 : length(ind_filtered)
    
    Y_s1 = fft(s1(ind_filtered(i),:));
    P2_s1 = abs(Y_s1/L);
    P1_s1 = P2_s1(1:L/2+1);
    P1_s1(2:end-1) = 2*P1_s1(2:end-1);
    
    Y_s2 = fft(s2(ind_filtered(i),:));
    P2_s2 = abs(Y_s2/L);
    P1_s2 = P2_s2(1:L/2+1);
    P1_s2(2:end-1) = 2*P1_s2(2:end-1);
    
    subplot(length(ind_filtered), 1, i)
    plot(f,P1_s1); hold on;
    plot(f, P1_s2); hold off; grid on;  xlim([0 5]);

    title(signal_label(ind_filtered(i)),...
      'interpreter','latex','FontUnits','points',...
      'FontWeight','demi','FontSize',8,'FontName','Times');

end
xlabel('f $[Hz]$','interpreter','latex','FontUnits',...
        'points','FontWeight','normal','FontSize',10,'FontName',...
        'Times');

sgtitle(sup_str,...
        'interpreter','latex','FontUnits','points',...
        'FontWeight','demi','FontSize',8,'FontName','Times');
end