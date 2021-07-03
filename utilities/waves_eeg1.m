function [percentalpha, percentbeta, percenttheta, percentdelta] = waves_eeg1(EEG, Fsample)
    Hs = spectrum.welch;
    Spectrum = psd(Hs,EEG,'Fs',Fsample);
    total=trapz(Spectrum.data);
    
    alpha=trapz(Spectrum.data(8:16));
    percentalpha= alpha/total;
    
    beta= trapz(Spectrum.data(16:32));
    percentbeta=beta/total;
    
    theta= trapz(Spectrum.data(4:8));
    percenttheta= theta/total;
    
    delta= trapz(Spectrum.data(1:4));
    percentdelta=delta/total;
end
