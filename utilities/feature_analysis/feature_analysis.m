%% Confusion matrix
figure(1);confusionchart(P5stages,stagesfit_ICAfilt); 
title('Confusion Matrix for model using ICA and filters');
figure(2);confusionchart(P5stages,stagesfit_noICA); 
title('Confusion Matrix for model using only filters');
figure(3);confusionchart(P5stages,stagesfit_ICA);
title('Confusion Matrix for model using only ICA');
figure(4);confusionchart(P5stages,stagesfit_raw);
title('Confusion Matrix for model using raw data');

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

%% features do EEG1 C4A1 (10 features por 4 EEG signals)
figure (1)
boxplot(P5features_noICA(:,1),stagesfit_noICA); title('alpha waves'); %todas as waves são boas para classificar
figure (2)
boxplot(P5features_noICA(:,2),stagesfit_noICA); title('beta waves'); % continua a ser bom, mas nao tanto quanto nos outros modelos
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
boxplot(P5features_noICA(:,8),stagesfit_noICA); title('hjorth activity'); % assim assim para 1 e 5
figure (9)
boxplot(P5features_noICA(:,9),stagesfit_noICA); title('hjorth mobility'); %nice
figure (10)
boxplot(P5features_noICA(:,10),stagesfit_noICA); title('hjorth complexity'); %nice
figure (11)
boxplot(P5features_noICA(:,11),stagesfit_noICA); title('k complexes'); %nice
figure (12)
boxplot(P5features_noICA(:,12),stagesfit_noICA); title('sleep spindles'); %nao é muito mau mas podia ser melhor (C4A1: sleep spindles)

% Comparing the results obtained using the model trainedModel_noICA
% (signals were only processed using filters before computing the feature
% matrix used to train the model), the distribution of each feature per
% sleep stage remains similar, although some features, such as beta waves
% and hjorth activity have worse results, which is a way of saying the
% distribution per sleep stage is not as good as before, and therefore
% these features will not help the classifier as much as before.

%% features do EEG2 C4P4 (12 features por 4 EEG signals)
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
boxplot(P5features_noICA(:,20),stagesfit_noICA); title('hjorth activity'); % pessimo, mas pode ajudar na stage 5
figure (9)
boxplot(P5features_noICA(:,21),stagesfit_noICA); title('hjorth mobility'); %nice
figure (10)
boxplot(P5features_noICA(:,22),stagesfit_noICA); title('hjorth complexity'); %nice mas pior que antes
figure (11)
boxplot(P5features_noICA(:,23),stagesfit_noICA); title('k complexes'); % bnom para stage 5 e 1
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
figure('color','w')
subplot(2, 2, 1)
boxplot(P5features_noICA(:,54),stagesfit_noICA); title('hr');%aumenta ligeiramente para awake e baixa para rem, mas os valores são semelhantes
subplot(2, 2, 2)
boxplot(P5features_noICA(:,55),stagesfit_noICA); title('mean hrv');%parecido entre stages
subplot(2, 2, 3)
boxplot(P5features_noICA(:,56),stagesfit_noICA); title('std hrv');%varia um pouco mas nao muito, pode ajudar
subplot(2, 2, 4)
boxplot(P5features_noICA(:,57),stagesfit_noICA); title('dif maxmin hrv');%bom para separa a 1 e 5 do resto

%% Sleep spindles between different EEG signals
% ICAfilt
figure ('color','w')
subplot(2, 2, 1)
boxplot(P5features_ICAfilt(:,12),stagesfit_ICAfilt,...
    'Labels',{'W', 'S1', 'S2', 'S3', 'S4', 'R'});

title('C4A1',...
    'interpreter','latex','FontUnits','points',...
    'FontWeight','demi','FontSize',16,'FontName','Times');
xlabel('sleep stages','interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',14,'FontName','Times');

subplot(2, 2, 2)
boxplot(P5features_ICAfilt(:,24),stagesfit_ICAfilt,...
    'Labels',{'W', 'S1', 'S2', 'S3', 'S4', 'R'});
title('C4P4',...
    'interpreter','latex','FontUnits','points',...
    'FontWeight','demi','FontSize',16,'FontName','Times');
xlabel('sleep stages','interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',14,'FontName','Times');

subplot(2, 2, 3)
boxplot(P5features_ICAfilt(:,36),stagesfit_ICAfilt,...
    'Labels',{'W', 'S1', 'S2', 'S3', 'S4', 'R'});
title('F4C4',...
    'interpreter','latex','FontUnits','points',...
    'FontWeight','demi','FontSize',16,'FontName','Times');
xlabel('sleep stages','interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',14,'FontName','Times');

subplot(2, 2, 4)
boxplot(P5features_ICAfilt(:,48),stagesfit_ICAfilt,...
    'Labels',{'W', 'S1', 'S2', 'S3', 'S4', 'R'});
title('P4O2',...
    'interpreter','latex','FontUnits','points',...
    'FontWeight','demi','FontSize',16,'FontName','Times');
xlabel('sleep stages','interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',14,'FontName','Times');

sgtitle('Sleep spindles between different EEG signals',...
    'interpreter','latex','FontUnits','points',...
    'FontWeight','demi','FontSize',18,'FontName','Times');


%% Only filters
figure (1)
boxplot(P5features_noICA(:,12),stagesfit_noICA); title('C4A1'); 
figure (2)
boxplot(P5features_noICA(:,24),stagesfit_noICA); title('C4P4'); 
figure (3)
boxplot(P5features_noICA(:,36),stagesfit_noICA); title('F4C4'); 
figure (4)
boxplot(P5features_noICA(:,48),stagesfit_noICA); title('P4O2'); 

% Only ICA
figure (1)
boxplot(P5features_ICA(:,12),stagesfit_ICA); title('C4A1'); 
figure (2)
boxplot(P5features_ICA(:,24),stagesfit_ICA); title('C4P4'); 
figure (3)
boxplot(P5features_ICA(:,36),stagesfit_ICA); title('F4C4'); 
figure (4)
boxplot(P5features_ICA(:,48),stagesfit_ICA); title('P4O2'); 

% Raw
figure (1)
boxplot(P5features_raw(:,12),stagesfit_raw); title('C4A1'); 
figure (2)
boxplot(P5features_raw(:,24),stagesfit_raw); title('C4P4'); 
figure (3)
boxplot(P5features_raw(:,36),stagesfit_raw); title('F4C4'); 
figure (4)
boxplot(P5features_raw(:,48),stagesfit_raw); title('P4O2'); 

% In all models, the sleep spindles feature only provides useful
% information when using th C4A1 channel (ARRANJAR UMA REFERÊNCIA PARA
% ISTO, E MAYBE UMA EXPLICAÇÃO)

% Comparing sleep spindles between types of pre-processing
figure ('color','w')
subplot(2, 2, 1)
boxplot(P5features_raw(:,12),stagesfit_raw); title('Raw'); 
subplot(2, 2, 2)
boxplot(P5features_ICA(:,12),stagesfit_ICA); title('Only ICA'); 
subplot(2, 2, 3)
boxplot(P5features_noICA(:,12),stagesfit_noICA); title('Only filters'); 
subplot(2, 2, 4)
boxplot(P5features_ICAfilt(:,12),stagesfit_ICAfilt); title('ICA + filters'); 

% Very similar, not really worth mentioning.

%% K-complexes between different EEG signals
% ICAfilt
figure (1)
subplot(2, 2, 1)
boxplot(P5features_ICAfilt(:,11),stagesfit_ICAfilt); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_ICAfilt(:,23),stagesfit_ICAfilt); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_ICAfilt(:,35),stagesfit_ICAfilt); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_ICAfilt(:,47),stagesfit_ICAfilt); title('P4O2'); 

% Only filters
figure (2)
subplot(2, 2, 1)
boxplot(P5features_noICA(:,11),stagesfit_noICA); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_noICA(:,23),stagesfit_noICA); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_noICA(:,35),stagesfit_noICA); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_noICA(:,47),stagesfit_noICA); title('P4O2'); 

% Only ICA
figure (3)
subplot(2, 2, 1)
boxplot(P5features_ICA(:,11),stagesfit_ICA); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_ICA(:,23),stagesfit_ICA); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_ICA(:,35),stagesfit_ICA); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_ICA(:,47),stagesfit_ICA); title('P4O2'); 

% Raw
figure (4)
subplot(2, 2, 1)
boxplot(P5features_raw(:,11),stagesfit_raw); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_raw(:,23),stagesfit_raw); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_raw(:,35),stagesfit_raw); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_raw(:,47),stagesfit_raw); title('P4O2'); 

% In all models, the obtained value for k-complexes per epoch showed a more
% variable distribution when using the C4A1 channel, suggesting that using
% only this channel to compute the k-complexes will offer enough
% information to the classifier, while reducing the amount of data provided
% and as a consequence the complexity of the models.

% Comparing k-complexes between types of pre-processing
figure ('color','w')
subplot(2, 2, 1)
boxplot(P5features_raw(:,11),stagesfit_raw); title('Raw'); 
% ylim([0 100]);
subplot(2, 2, 2)
boxplot(P5features_ICA(:,11),stagesfit_ICA); title('Only ICA'); 
% ylim([0 100]);
subplot(2, 2, 3)
boxplot(P5features_noICA(:,11),stagesfit_noICA); title('Only filters'); 
% ylim([0 100]);
subplot(2, 2, 4)
boxplot(P5features_ICAfilt(:,11),stagesfit_ICAfilt); title('ICA + filters'); 
% ylim([0 100]);

% Results are very similar between the different approaches.

%% PFD between different EEG signals
% ICAfilt
figure (1)
subplot(2, 2, 1)
boxplot(P5features_ICAfilt(:,7),stagesfit_ICAfilt); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_ICAfilt(:,19),stagesfit_ICAfilt); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_ICAfilt(:,31),stagesfit_ICAfilt); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_ICAfilt(:,43),stagesfit_ICAfilt); title('P4O2'); 

% Only filters
figure (2)
subplot(2, 2, 1)
boxplot(P5features_noICA(:,7),stagesfit_noICA); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_noICA(:,19),stagesfit_noICA); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_noICA(:,31),stagesfit_noICA); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_noICA(:,43),stagesfit_noICA); title('P4O2'); 

% Only ICA
figure (3)
subplot(2, 2, 1)
boxplot(P5features_ICA(:,7),stagesfit_ICA); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_ICA(:,19),stagesfit_ICA); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_ICA(:,31),stagesfit_ICA); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_ICA(:,43),stagesfit_ICA); title('P4O2'); 

% Raw
figure (4)
subplot(2, 2, 1)
boxplot(P5features_raw(:,7),stagesfit_raw); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_raw(:,19),stagesfit_raw); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_raw(:,31),stagesfit_raw); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_raw(:,43),stagesfit_raw); title('P4O2'); 

%% Kurtosis between different EEG signals
% ICAfilt
figure (1)
subplot(2, 2, 1)
boxplot(P5features_ICAfilt(:,5),stagesfit_ICAfilt); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_ICAfilt(:,17),stagesfit_ICAfilt); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_ICAfilt(:,29),stagesfit_ICAfilt); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_ICAfilt(:,41),stagesfit_ICAfilt); title('P4O2'); 

% Only filters
figure (2)
subplot(2, 2, 1)
boxplot(P5features_noICA(:,5),stagesfit_noICA); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_noICA(:,17),stagesfit_noICA); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_noICA(:,29),stagesfit_noICA); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_noICA(:,41),stagesfit_noICA); title('P4O2'); 

% Only ICA
figure (3)
subplot(2, 2, 1)
boxplot(P5features_ICA(:,5),stagesfit_ICA); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_ICA(:,17),stagesfit_ICA); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_ICA(:,29),stagesfit_ICA); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_ICA(:,41),stagesfit_ICA); title('P4O2'); 

% Raw
figure (4)
subplot(2, 2, 1)
boxplot(P5features_raw(:,5),stagesfit_raw); title('C4A1'); 
subplot(2, 2, 2)
boxplot(P5features_raw(:,17),stagesfit_raw); title('C4P4'); 
subplot(2, 2, 3)
boxplot(P5features_raw(:,29),stagesfit_raw); title('F4C4'); 
subplot(2, 2, 4)
boxplot(P5features_raw(:,41),stagesfit_raw); title('P4O2'); 

%% Analysis using ICA and filters
% EEG features In general, alpha, beta, theta and delta waves are good
% features to use for classification, while skewness does not offer much
% information regarding the stages. Some features help distinguish between
% one stage and the others, such as kurtosis, k-complexes and hjorth
% activity, which help identify epochs in stage 5. However, the other
% hjorth features (mobility and complexity), PFD, Moreover, the EEG signal
% corresponding to C4A1 is particularly useful in identifying sleep
% spindles, which in turn means this feature is better to classify than
% sleep spindles obtained using other channels (POR AQUI REFERENCIA E
% JUSTIFICAÇÃO MAYBE). In all models, the obtained values for k-complexes
% per epoch showed a more variable distribution when using the C4A1
% channel, suggesting that using only this channel to compute the
% k-complexes will offer enough information to the classifier, while
% reducing the amount of data provided and as a consequence the complexity
% of the models.

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

%% Alternative feature matrix considering the feature analysis above
% pfd, k-complexes & spindles only from C4A1: 7, 11, 12 (excluding 19, 23,
% 24, 31, 35, 36, 43, 47, 48) 
% remove skewness:6, 18, 30, 42

remove = [6,18,19,23,24,30,31,35,36,42,43,47,48];
features_reduced_ICAfilt = features_ICAfilt(:,setdiff(1:57, remove));
P5features_reduced_ICAfilt = P5features_ICAfilt(:,setdiff(1:57, remove));

% ICA + filt com menos features
stagesfit_reduced_ICAfilt=trainedModel_reduced_ICAfilt.predictFcn(P5features_reduced_ICAfilt); %prediction of stages
n=0;
for i=1:length(P5stages)
    if P5stages(i)==stagesfit_reduced_ICAfilt(i)
        n=n+1;
    end
end

acc_reduced_ICAfilt = n/length(P5stages)*100;
clear i n

display("The algorithm has an accuracy of " + acc_reduced_ICAfilt +"%")

figure()
plot(stagesfit_reduced_ICAfilt);hold on
plot(P5stages); hold off
title("Hypnogram real vs ML")
legend({'real','ML'},'Location','southeast')
ylim([0 5])
xlim([0 length(P5stages)])
xlabel("Epoch Number")
ylabel("Sleep Stages")
set(gca,'ytick',[0:5],'yticklabel',{'REM','N4','N3','N2','N1','Wake'});

figure()
confusionchart(P5stages,stagesfit_reduced_ICAfilt)

