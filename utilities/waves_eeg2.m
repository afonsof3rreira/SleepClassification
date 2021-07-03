function [percentalpha, percentbeta, percenttheta, percentdelta,percentgamma] = waves_eeg2(signal, Fs)


waveletName='db8';
level=log2(Fs)-2;

% Multilevel 1-D wavelet decomposition for channel 0
[c0,l0]=wavedec(signal,level,waveletName);
signalpower = (sum(signal.^2))/length(signal);
% 1-D detail coefficients
cD1 = detcoef(c0,l0,level-3); %GAMMA
percentgamma = (sum(cD1.^2))/length(cD1)/signalpower;

cD2 = detcoef(c0,l0,level-2); %BETA
percentbeta = (sum(cD2.^2))/length(cD2)/signalpower;

cD3 = detcoef(c0,l0,level-1); %ALPHA
percentalpha = (sum(cD3.^2))/length(cD3)/signalpower;

cD4 = detcoef(c0,l0,level); %THETA
percenttheta = (sum(cD4.^2))/length(cD4)/signalpower;

cA4 = appcoef(c0,l0,waveletName,level); %DELTA
percentdelta = (sum(cA4.^2))/length(cA4)/signalpower;
end
