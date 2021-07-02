function [percentalpha, percentbeta, percenttheta, percentdelta] = waves_eeg1(EEG, Fsample)
    Hs = spectrum.welch;
    Spectrum = psd(Hs,EEG,'Fs',Fsample);
    total= trapz(Spectrum.data);
    
    alpha=trapz(Spectrum.data(9:14));
    percentalpha= alpha/total;
    
    beta= trapz(Spectrum.data(14:31));
    percentbeta=beta/total;
    
    theta= trapz(Spectrum.data(5:9));
    percenttheta= theta/total;
    
    delta= trapz(Spectrum.data(1:5));
    percentdelta=delta/total;
end
