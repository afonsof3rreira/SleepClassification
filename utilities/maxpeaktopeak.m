function [amp] = maxpeaktopeak(signal)
maxpos=max(findpeaks(signal));
maxneg=max(findpeaks(-signal));
amp=maxpos+maxneg;
end

