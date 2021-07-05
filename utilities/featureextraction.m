function [features] = featureextraction(EEG1,EEG2,ECG,EMG1,EEG3,HR,EEG4,EOG,EMG2, sfs)
%featureextraction selects the features of each signal putting them in a vector
features=[];

%EEG features
EEG=[EEG1; EEG2; EEG3; EEG4];
for i=1:4
    if i<3 
        sf=sfs(i);
    elseif i==3
        sf=sfs(5);
    else
        sf=sfs(7);
    end
    
    eeg=EEG(i,:);deeg=gradient(eeg,1/sf);ddeeg=gradient(deeg,1/sf);
    n=length(eeg);
    
    %calculo das features
    waves=waves_eeg1(eeg, sf);
    kurt=kurtosis(eeg);
    sk=skewness(eeg);
    zc=zerocrossings(deeg); pfd=log10(n)/(log10(n)+log10(n/(n+0.4*zc)));
    v0=var(eeg);v1=var(deeg);v2=var(ddeeg);
    hjorth=[(v0^2) v1/v2 sqrt((v2/c1)^2-(v1/v0)^2)];
    
    
    features=[features waves kurt sk pfd hjorth];
end

%EMG features
rms1=rootmeansquare(EMG1);
rms2=rootmeansquare(EMG2);
pp1=maxpeaktopeak(EMG1);
pp2=maxpeaktopeak(EMG2);

features=[features rms1 rms2 pp1 pp2];
%EOG features
nblinks = blinks(EOG, sfs(8));features=[features nblinks];

%ECG features
hr=mean(HR);
hrv=HRintervals(ECG);
meaninterval=mean(hrv);
stdinterval=std(hrv);
difmaxmin=max(hrv)-min(hrv);
features=[features hr meaninterval stdinterval difmaxmin];
end

