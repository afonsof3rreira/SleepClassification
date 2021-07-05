function [HRintervals] = HRintervals(ECG)
sf=512; %always

ECG=-ECG;
[~,LOCS] = findpeaks(ECG,'MinPeakHeight',100,'MinPeakDistance',400);
HRintervals=zeros(1,length(LOCS)-1);
for i=2:length(LOCS)
    HRintervals(i-1)=(LOCS(i)-LOCS(i-1))/sf;
end
end

