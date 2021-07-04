function [percentalpha, percentbeta, percenttheta, percentdelta] = waves_eeg1(EEG, sf)
    Hs = spectrum.welch;
    Spectrum = psd(Hs,EEG,'Fs',sf);
    total=trapz(Spectrum.data);
    
    alpha=trapz(Spectrum.data(8:13));
    percentalpha= alpha/total;
    
    beta= trapz(Spectrum.data(18:25));
    percentbeta=beta/total;
    
    theta= trapz(Spectrum.data(4:8));
    percenttheta= theta/total;
    
    delta= trapz(Spectrum.data(1:2));
    percentdelta=delta/total;
end
