function plotimfs(x,sf)

imfA = emd(x);

for i=1:size(imfA,1)
	imf{i}=imfA(i,:);
end
M = length(imf);

% Set time-frequency plots.
N = length(x);

%plot x, imfs and residue
figure('Position', [361,1,563,696])
c = linspace(0,(N-1)/sf,N);

%plot x
subplot(M+1, 1, 1);
plot(c,x)
grid on; grid minor;
title("Signal");
% Set IMF plots.
for i = 2: M + 1
    subplot(M + 1, 1, i);
    grid on; grid minor;
    plot(c, imf{i-1});
    grid on; grid minor;
    imf_ind = i-1;
    ylabel("IMF" + imf_ind);
end
xlabel('Time');

figure('Position', [361,1,563,696])
[spectrum,F]=periodogram(x,hann(N),N,sf);
ax(1)=subplot(M+1, 1, 1);
plot(F,spectrum)
for i=2:M+1
	[spectrum,F]=periodogram(imf{i-1},hann(N),N,sf);
    ax(i)=subplot(M+1, 1, i);
    plot(F,spectrum)
    imf_ind = i-1;
    ylabel("IMF" + imf_ind);
end
linkaxes(ax,'x');

end

