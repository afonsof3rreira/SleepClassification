%% Confusion matrix
figure(1)
cm = confusionchart(P5stages,stagesfit_ICAfilt,...
    'Title','Confusion Matrix for model using ICA and filters');

%%
figure(2);confusionchart(P5stages,stagesfit_noICA); title('Filters');
figure(3);confusionchart(P5stages,stagesfit_ICA); title('ICA');
figure(4);confusionchart(P5stages,stagesfit_raw); title('raw');

%% ICA + filters
stagesfit_ICAfilt = trainedModel_ICAfilt.predictFcn(P5features_ICAfilt);

%% Box plots
figure ()
boxplot(P5features_ICAfilt(:,53),stagesfit_ICAfilt); title('number of blinks'); % number of blinks (só tem valores diferentes de zeor na stage 5, o que faz sentido)
figure ()
boxplot(P5features_ICAfilt(:,55),stagesfit_ICAfilt); title('heart rate'); % heart rate
figure ()
boxplot(P5features_ICAfilt(:,42),stagesfit_ICAfilt); title('delta waves'); % delta waves pouco util
figure ()
boxplot(P5features_ICAfilt(:,41),stagesfit_ICAfilt); title('theta waves'); % theta waves
figure ()
boxplot(P5features_ICAfilt(:,40),stagesfit_ICAfilt); title('beta waves'); % beta waves
figure ()
boxplot(P5features_ICAfilt(:,39),stagesfit_ICAfilt); title('alpha waves'); % alpha waves

%% features do EEG1 (10 features por 4 EEG signals)
figure (1)
boxplot(P5features_ICAfilt(:,1),stagesfit_ICAfilt); title('alpha waves'); %todas as waves são boas para classificar
figure (2)
boxplot(P5features_ICAfilt(:,2),stagesfit_ICAfilt); title('beta waves');
figure (3)
boxplot(P5features_ICAfilt(:,3),stagesfit_ICAfilt); title('theta waves');
figure (4)
boxplot(P5features_ICAfilt(:,4),stagesfit_ICAfilt); title('delta waves'); 
figure (5)
boxplot(P5features_ICAfilt(:,5),stagesfit_ICAfilt); title('kurtosis'); % tendencialmente maior para stage 5 mas mesmo assim varia um bocado entre stages
figure (6)
boxplot(P5features_ICAfilt(:,6),stagesfit_ICAfilt); title('skewness'); %varia muito pouco entre stages
figure (7)
boxplot(P5features_ICAfilt(:,7),stagesfit_ICAfilt); title('pfd'); %nice
figure (8)
boxplot(P5features_ICAfilt(:,8),stagesfit_ICAfilt); title('hjorth activity'); % bom para stage 5
figure (9)
boxplot(P5features_ICAfilt(:,9),stagesfit_ICAfilt); title('hjorth mobility'); %nice
figure (10)
boxplot(P5features_ICAfilt(:,10),stagesfit_ICAfilt); title('hjorth complexity'); %nice
figure (11)
boxplot(P5features_ICAfilt(:,11),stagesfit_ICAfilt); title('k complexes'); %nice
figure (12)
boxplot(P5features_ICAfilt(:,12),stagesfit_ICAfilt); title('sleep spindles'); %nao é muito mau mas podia ser melhor (C4A1: sleep spindles)

%% features do EEG2 (12 features por 4 EEG signals)
figure (1)
boxplot(P5features_ICAfilt(:,13),stagesfit_ICAfilt); title('alpha waves'); %todas as waves são boas para classificar
figure (2)
boxplot(P5features_ICAfilt(:,14),stagesfit_ICAfilt); title('beta waves');
figure (3)
boxplot(P5features_ICAfilt(:,15),stagesfit_ICAfilt); title('theta waves');
figure (4)
boxplot(P5features_ICAfilt(:,16),stagesfit_ICAfilt); title('delta waves'); 
figure (5)
boxplot(P5features_ICAfilt(:,17),stagesfit_ICAfilt); title('kurtosis'); % tendencialmente maior para stage 5 mas mesmo assim varia um bocado entre stages
figure (6)
boxplot(P5features_ICAfilt(:,18),stagesfit_ICAfilt); title('skewness'); %varia muito pouco entre stages
figure (7)
boxplot(P5features_ICAfilt(:,19),stagesfit_ICAfilt); title('pfd'); %nice
figure (8)
boxplot(P5features_ICAfilt(:,20),stagesfit_ICAfilt); title('hjorth activity'); % bom para stage 5
figure (9)
boxplot(P5features_ICAfilt(:,21),stagesfit_ICAfilt); title('hjorth mobility'); %nice
figure (10)
boxplot(P5features_ICAfilt(:,22),stagesfit_ICAfilt); title('hjorth complexity'); %nice
figure (11)
boxplot(P5features_ICAfilt(:,23),stagesfit_ICAfilt); title('k complexes'); % bnom para stage 5
figure (12)
boxplot(P5features_ICAfilt(:,24),stagesfit_ICAfilt); title('sleep spindles'); %pessimo

%% features do EMG
figure (1)
boxplot(P5features_ICAfilt(:,49),stagesfit_ICAfilt); title('rms emg1');
figure (2)
boxplot(P5features_ICAfilt(:,50),stagesfit_ICAfilt); title('rms emg2');
figure (3)
boxplot(P5features_ICAfilt(:,51),stagesfit_ICAfilt); title('pp emg1');
figure (4)
boxplot(P5features_ICAfilt(:,52),stagesfit_ICAfilt); title('pp emg2');

%% features do EOG
figure (1)
boxplot(P5features_ICAfilt(:,53),stagesfit_ICAfilt); title('#blinks');

%% features do ECG
figure (1)
boxplot(P5features_ICAfilt(:,54),stagesfit_ICAfilt); title('hr');%aumenta ligeiramente para awake e baixa para rem, mas os valores são semelhantes
figure (2)
boxplot(P5features_ICAfilt(:,55),stagesfit_ICAfilt); title('mean hrv');%parecido entre stages
figure (3)
boxplot(P5features_ICAfilt(:,56),stagesfit_ICAfilt); title('std hrv');%varia um pouco mas nao muito, pode ajudar
figure (4)
boxplot(P5features_ICAfilt(:,57),stagesfit_ICAfilt); title('dif maxmin hrv');%bom para separa a 1 e 5 do resto

%% Only filters
stagesfit_noICA = trainedModel_ICAfilt.predictFcn(P5features_noICA);

%% features do EEG1 (10 features por 4 EEG signals)
figure (1)
boxplot(P5features_noICA(:,1),stagesfit_noICA); title('alpha waves'); %todas as waves são boas para classificar
figure (2)
boxplot(P5features_noICA(:,2),stagesfit_noICA); title('beta waves');
figure (3)
boxplot(P5features_noICA(:,3),stagesfit_noICA); title('theta waves');
figure (4)
boxplot(P5features_noICA(:,4),stagesfit_noICA); title('delta waves'); 
figure (5)
boxplot(P5features_noICA(:,5),stagesfit_noICA); title('kurtosis'); % tendencialmente maior para stage 5 mas mesmo assim varia um bocado entre stages
figure (6)
boxplot(P5features_noICA(:,6),stagesfit_noICA); title('skewness'); %varia muito pouco entre stages
figure (7)
boxplot(P5features_noICA(:,7),stagesfit_noICA); title('pfd'); %nice
figure (8)
boxplot(P5features_noICA(:,8),stagesfit_noICA); title('hjorth activity'); % bom para stage 5
figure (9)
boxplot(P5features_noICA(:,9),stagesfit_noICA); title('hjorth mobility'); %nice
figure (10)
boxplot(P5features_noICA(:,10),stagesfit_noICA); title('hjorth complexity'); %nice
figure (11)
boxplot(P5features_noICA(:,11),stagesfit_noICA); title('k complexes'); %nice
figure (12)
boxplot(P5features_noICA(:,12),stagesfit_noICA); title('sleep spindles'); %nao é muito mau mas podia ser melhor (C4A1: sleep spindles)

%% features do EEG2 (12 features por 4 EEG signals)
figure (1)
boxplot(P5features_noICA(:,13),stagesfit_noICA); title('alpha waves'); %todas as waves são boas para classificar
figure (2)
boxplot(P5features_noICA(:,14),stagesfit_noICA); title('beta waves');
figure (3)
boxplot(P5features_noICA(:,15),stagesfit_noICA); title('theta waves');
figure (4)
boxplot(P5features_noICA(:,16),stagesfit_noICA); title('delta waves'); 
figure (5)
boxplot(P5features_noICA(:,17),stagesfit_noICA); title('kurtosis'); % tendencialmente maior para stage 5 mas mesmo assim varia um bocado entre stages
figure (6)
boxplot(P5features_noICA(:,18),stagesfit_noICA); title('skewness'); %varia muito pouco entre stages
figure (7)
boxplot(P5features_noICA(:,19),stagesfit_noICA); title('pfd'); %nice
figure (8)
boxplot(P5features_noICA(:,20),stagesfit_noICA); title('hjorth activity'); % bom para stage 5
figure (9)
boxplot(P5features_noICA(:,21),stagesfit_noICA); title('hjorth mobility'); %nice
figure (10)
boxplot(P5features_noICA(:,22),stagesfit_noICA); title('hjorth complexity'); %nice
figure (11)
boxplot(P5features_noICA(:,23),stagesfit_noICA); title('k complexes'); % bnom para stage 5
figure (12)
boxplot(P5features_noICA(:,24),stagesfit_noICA); title('sleep spindles'); %pessimo

%% features do EMG
figure (1)
boxplot(P5features_noICA(:,49),stagesfit_noICA); title('rms emg1');
figure (2)
boxplot(P5features_noICA(:,50),stagesfit_noICA); title('rms emg2');
figure (3)
boxplot(P5features_noICA(:,51),stagesfit_noICA); title('pp emg1');
figure (4)
boxplot(P5features_noICA(:,52),stagesfit_noICA); title('pp emg2');

%% features do EOG
figure (1)
boxplot(P5features_noICA(:,53),stagesfit_noICA); title('#blinks'); % number of blinks (só tem valores diferentes de zeor na stage 5, o que faz sentido)

%% features do ECG
figure (1)
boxplot(P5features_noICA(:,54),stagesfit_noICA); title('hr');%aumenta ligeiramente para awake e baixa para rem, mas os valores são semelhantes
figure (2)
boxplot(P5features_noICA(:,55),stagesfit_noICA); title('mean hrv');%parecido entre stages
figure (3)
boxplot(P5features_noICA(:,56),stagesfit_noICA); title('std hrv');%varia um pouco mas nao muito, pode ajudar
figure (4)
boxplot(P5features_noICA(:,57),stagesfit_noICA); title('dif maxmin hrv');%bom para separa a 1 e 5 do resto

%% Analysis using ICA and filters
% EEG features
% In general, alpha, beta, theta and delta waves are good features to use
% for classification, while skewness does not offer much information
% regarding the stages. Some features help distinguish between one stage
% and the others, such as kurtosis, k-complexes and hjorth activity, which
% help identify epochs in stage 5. However, the other hjorth features
% (mobility and complexity), PFD, Moreover, the EEG signal corresponding to
% C4A1 is particularly useful in identifying sleep spindles, which in turn
% means this feature is better to classify than sleep spindles obtained
% using other channels.

% EMG features
% All EMG features computed have distinct values during stage 5 (wake, i'm
% guessing). During the awake periods, the movement of the patient increases
% unlike during sleep when the patient is still. As a result, EMG related
% features are useful to distinguish between awake and asleep phases of
% sleep.

% EOG features
% For the EOG signal, the only feature computed was the number of blinks.
% Analysing the results, the number obtained is higher for the wake stage,
% but there are some blinks detected during other phases of sleep, which
% is not realistic. Hence, blink detection probalbly is not being done
% correctly. However, the number of detected blinks is tendentially higher
% in the awake stage, which is expected, so it is a usefull feature to
% separate this stage from the others.