function [ss] = sleepspindles2(EEG,sf)
eegemd=emd(EEG);
eeg=eegemd(2,:)+eegemd(3,:);
ss=bandpower(eeg,sf,[10 16]);
end

