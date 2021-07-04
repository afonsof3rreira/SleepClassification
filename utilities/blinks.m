function [nblinks] = blinks(EOG, sf)
%yelds the number of blinks detected
warning('off','all')
[peaks,~]=findpeaks(EOG,sf,'MinPeakHeight',75,'MinPeakDistance',round(500/sf));
nblinks=length(peaks);
end

