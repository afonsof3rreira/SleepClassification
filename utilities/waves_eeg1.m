function [percentalpha, percentbeta, percenttheta, percentdelta] = waves_eeg1(EEG, Fsample)
    Hs = spectrum.welch;
    Spectrum = psd(Hs,EEG,'Fs',Fsample);
    
    alpha=trapz(Spectrum.data(9:16));
    percentalpha= alpha;
    
    beta= trapz(Spectrum.data(17:32));
    percentbeta=beta;
    
    theta= trapz(Spectrum.data(5:8));
    percenttheta= theta;
    
    delta= trapz(Spectrum.data(1:4));
    percentdelta=delta;
end
