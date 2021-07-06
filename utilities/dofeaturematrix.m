function [features,ss] = dofeaturematrix(segmentedsignals,sleepstages,sfs)
% features is the feature matrix where each row is a epoch
% ss is the column vector of the sleep stages

ss=[];
for i=1:length(sleepstages)
    ss=[ss;sleepstages{i,1}];
end

[npatient, ~]=size(segmentedsignals);

features=[];
for p=1:npatient
    [nepochs,~]=size(segmentedsignals{p,1});
    for epoch=1:nepochs
        EEG1=segmentedsignals{p,1}(epoch,:);
        EEG2=segmentedsignals{p,2}(epoch,:);
        ECG=segmentedsignals{p,3}(epoch,:);
        EMG1=segmentedsignals{p,4}(epoch,:);
        EEG3=segmentedsignals{p,5}(epoch,:);
        HR=segmentedsignals{p,6}(epoch,:);
        EEG4=segmentedsignals{p,7}(epoch,:);
        EOG=segmentedsignals{p,8}(epoch,:);
        EMG2=segmentedsignals{p,9}(epoch,:);
        
        epochfeatures=featureextraction(EEG1,EEG2,ECG,EMG1,EEG3,HR,EEG4,EOG,EMG2, sfs);
        features=[features; epochfeatures];
    end
end

end

