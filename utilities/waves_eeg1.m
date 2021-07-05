function [percentalpha, percentbeta, percenttheta, percentdelta] = waves_eeg1(EEG, sf)
total=bandpower(EEG,sf,[0 sf/2]);

alpha=bandpower(EEG,sf,[8 13]);percentalpha= alpha/total;

beta= bandpower(EEG,sf,[18 25]);percentbeta=beta/total;

theta= bandpower(EEG,sf,[4 8]);percenttheta= theta/total;

delta= bandpower(EEG,sf,[0.5 2]);percentdelta=delta/total;
end
