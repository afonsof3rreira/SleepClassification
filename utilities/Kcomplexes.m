function [n]= Kcomplexes(EEG, Fsample)
warning('off','all')
threshold= Fsample*0.5; %sample number that corresponds to 0.5s
[peaks, local]=findpeaks(EEG,'MinPeakHeight', 30, 'MinPeakDistance', threshold);

[peaksneg, localneg]=findpeaks(-EEG,'MinPeakHeight', 30, 'MinPeakDistance', threshold);

n=0;
if ~isempty(peaks) && ~isempty(peaksneg)
    for i= 1:length(peaksneg)
        for j = 1:length(peaks)
            if abs(local(j)-localneg(i))<=3*threshold && local(j)-localneg(i)<0
                if peaks(j)+peaksneg(i)>75
                    n=n+1;
                end
            end
        end
    end
end
end