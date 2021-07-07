%% PDSB Project

clear
close all
warning('off','all')
%% 1. Retreiving raw data dirs and filenames, getting channels and headers
% EDF files: raw data
% TXT files: annotated sleep stages

% save edf files and txt files in separate directories as below
FileNames_edf = get_filenames_from_path('./data/raw_data/original/Files_edf');
FileNames_txt = get_filenames_from_path('./data/raw_data/original/Files_txt');

signal_header=cell(5,1);
for i=1:length(FileNames_edf)
    [header,channels]=edfread(FileNames_edf{i});
    disp("file "+i+" of 5 done")
    switch i
        case 1
            n1 = channels;
        case 2
            n2 = channels;
        case 3 
            n3 = channels;
        case 4
            n5 = channels;
        case 5
            n11 = channels;
    end
    signal_header{i}=header;
end

% cleaning uneeded vars
clear FileNames_edf i channels header

%% 2.A. Saving header

save('./data/raw_data/mat_files/signal_header.mat','signal_header')
disp("header saved")

%% 3. checking all available different signals for a given signal header

% Save output variables for a more detailed checking
[~, ~] = check_all_avail_signals(signal_header);

%% 4. Selecting signals types common to all patients / datasets

[common_labs, common_transds] = check_common_signals(signal_header);
ib = zeros(length(signal_header), length(common_transds));

[~, ~, ib(1, :)] = intersect(common_labs, signal_header{1, 1}.label);
n1 = n1(ib(1, :), :);

[~, ~, ib(2, :)] = intersect(common_labs, signal_header{2, 1}.label);
n2 = n2(ib(2, :), :);

[~, ~, ib(3, :)] = intersect(common_labs, signal_header{3, 1}.label);
n3 = n3(ib(3, :), :);

[~, ~, ib(4, :)] = intersect(common_labs, signal_header{4, 1}.label);
n5 = n5(ib(4, :), :);

[~, ~, ib(5, :)] = intersect(common_labs, signal_header{5, 1}.label);
n11 = n11(ib(5, :), :);



%% 5. Selecting sampling frequencies of the selected signals

samplingfrequencies=zeros(5,length(common_labs));
for p=1:5
    for i=1:length(common_labs)
        j=1;
        while j<length(signal_header{p}.label)
            if signal_header{p}.label(j)==common_labs(i)
                samplingfrequencies(p,i)=signal_header{p}.samples(j);
            end
            j=j+1;
        end
    end
end

clear p i j

%% 6.A Saving selected signals, sampling freqs and info

save('./data/raw_data/mat_files/samplingfrequencies.mat','samplingfrequencies')
disp("sampling frequencies saved")

selection_info = [common_labs; common_transds];
save('./data/raw_data/mat_files/selection_info.mat','selection_info')
disp("selected info saved")

save('./data/raw_data/mat_files/n1.mat', 'n1', '-v7.3')
disp("n1 saved")

save('./data/raw_data/mat_files/n2.mat', 'n2', '-v7.3')
disp("n2 saved")

save('./data/raw_data/mat_files/n3.mat', 'n3', '-v7.3')
disp("n3 saved")

save('./data/raw_data/mat_files/n5.mat', 'n5', '-v7.3')
disp("n5 saved")

save('./data/raw_data/mat_files/n11.mat', 'n11', '-v7.3')
disp("n11 saved")

clear common_labs common_transds

%% 6.B Loading selected signals, sampling freqs and info

load('./data/raw_data/mat_files/selection_info.mat');disp("selected info loaded")
load('./data/raw_data/mat_files/samplingfrequencies.mat');disp("sfs loaded")
load('./data/raw_data/mat_files/signal_header.mat');disp("header loaded")
load('./data/raw_data/mat_files/n1.mat');disp("n1 loaded")
load('./data/raw_data/mat_files/n2.mat');disp("n2 loaded")
load('./data/raw_data/mat_files/n3.mat');disp("n3 loaded")
load('./data/raw_data/mat_files/n5.mat');disp("n5 loaded")
load('./data/raw_data/mat_files/n11.mat');disp("n11 loaded")

%% 7. Segment signals
segmentedsignals=cell(5,9);
names={'n1','n2','n3','n5','n11'}; % names of variables we are segmenting in 30s epochs
for i=1:length(names)
    patient=eval(names{i});
    for j=1:9
    segmentedsignals{i,j}=segmentsignal(patient(j,:), samplingfrequencies(i,j));
    end
end
clear i j patient

% Synchronize with stages txt files
for i=1:9
    segmentedsignals{1,i}=segmentedsignals{1,i}(8:end-6,:);
    segmentedsignals{2,i}=segmentedsignals{2,i}(3:end,:);
    segmentedsignals{3,i}=segmentedsignals{3,i}(375:end-97,:);
    segmentedsignals{4,i}=segmentedsignals{4,i}(102:end-2,:);
    segmentedsignals{5,i}=segmentedsignals{5,i}(41:end-2,:);
end

clear i names patient %samplingfrequencies


%% 8. Read txt (ground truths)
% turn txts into column vector
sleepstages=cell(5,1);
for i=1:length(FileNames_txt)
    ss = txt_to_stages(FileNames_txt{i});
    sleepstages{i,1} = ss;
    disp(i+"/"+length(FileNames_txt)+" done")
end
clear i ss



%% 9.A Save segmented signals and sleepstages

save('./data/segmented_signals/segmentedsignals.mat', 'segmentedsignals', '-v7.3');
disp("segmentedsignals saved")

save('./data/ground_truth/sleepstages.mat', 'sleepstages', '-v7.3');
disp("sleepstages saved")

%% 9.B Load segmented signals and sleepstages
load('./Selected_dataset/segmentedsignals.mat');disp("segmentedsignals loaded")
load('./Selected_dataset/sleepstages.mat');disp("sleepstages loaded")

%% 10. Getting time arrays of the original signals

time_mat = get_time_arrays_from_sfs(signal_header, samplingfrequencies);


%% 11. plotting signals

plot_signals([n1, n2, n3, n5, n11], time_mat, ["n1", "n2", "n3", "n5", "n11"], selection_info, false);

%% 12. Checking which signals to upsample

max_sfs = check_s_freqs(ib, signal_header);

%% 13. Upsampling signals to the maximum signals of each type

disp("n1...");
n1_ = upsample_signals(n1, signal_header{1, 1}, ib(1, :), max_sfs, time_mat{1, 1});

disp("n2...");
n2_ = upsample_signals(n2, signal_header{2, 1}, ib(2, :), max_sfs, time_mat{2, 1});

disp("n3...");
n3_ = upsample_signals(n3, signal_header{3, 1}, ib(3, :), max_sfs, time_mat{3, 1});

disp("n5...");
n5_ = upsample_signals(n5, signal_header{4, 1}, ib(4, :), max_sfs, time_mat{4, 1});

disp("n11...");
n11_ = upsample_signals(n11, signal_header{5, 1}, ib(5, :), max_sfs, time_mat{5, 1});

%% 14. Plotting one signal (n1) to confirm upsampling

plot_1v1_resample(n1, n1_, time_mat{1, 1}, "n1", selection_info, false, false, 10);
plot_1v1_resample(n1, n1_, time_mat{1, 1}, "n1", selection_info, false, true, 0.25);

%% clear unneded vars from now on to decreasy memory usage

clear n1 n2 n3 n5 n11

%% 15.A Saving resampled signals: SAVE IF YOU'RE RESTARTING THE PIPELINE

disp("...saving resampled data");

time_vec = time_mat{1, 1}{1, 1};

save('./data/resampled_signals/time_vec.mat','time_vec')
disp("time saved")

save('./data/resampled_signals/n1_.mat', 'n1_', '-v7.3')
disp("n1 saved")

save('./data/resampled_signals/n2_.mat', 'n2_', '-v7.3')
disp("n2 saved")

save('./data/resampled_signals/n3_.mat', 'n3_', '-v7.3')
disp("n3 saved")

save('./data/resampled_signals/n5_.mat', 'n5_', '-v7.3')
disp("n5 saved")

save('./data/resampled_signals/n11_.mat', 'n11_', '-v7.3')
disp("n11 saved")

%% 15.B Load resampled signals

load('./data/raw_data/mat_files/signal_header.mat');disp("signal header loaded")
load('./data/raw_data/mat_files/selection_info.mat');disp("signal info loaded")
load('./Resampled_dataset/time_vec.mat');disp("time vector loaded")
load('./data/resampled_signals/n1.mat');disp("n1 loaded")
load('./data/resampled_signals/n2.mat');disp("n2 loaded")
load('./data/resampled_signals/n3.mat');disp("n3 loaded")
load('./data/resampled_signals/n5.mat');disp("n5 loaded")
load('./data/resampled_signals/n11.mat');disp("n11 loaded")

%% 16. Performing z-score normalization followed by ICA

mu_data = zeros(5, 9);
mean_data = zeros(5, 9);

[fastica_result_n1, n1_n, mu_data, mean_data] = fastICA_norm(n1_, mu_data, mean_data, 1);
[fastica_result_n2, n2_n, mu_data, mean_data] = fastICA_norm(n2_, mu_data, mean_data, 2);
[fastica_result_n3, n3_n, mu_data, mean_data] = fastICA_norm(n3_, mu_data, mean_data, 3);
[fastica_result_n5, n5_n, mu_data, mean_data] = fastICA_norm(n5_, mu_data, mean_data, 4);
[fastica_result_n11, n11_n, mu_data, mean_data] = fastICA_norm(n11_, mu_data, mean_data, 5);

%% 17.A saving ICA results - fastICA results: SKIP TO SAVE DISK SPACE

% ICA components
save('./data/resampled_signals/ICA_components/fastica_result_n1.mat', 'fastica_result_n1', '-v7.3');
save('./data/resampled_signals/ICA_components/fastica_result_n2.mat', 'fastica_result_n2', '-v7.3');
save('./data/resampled_signals/ICA_components/fastica_result_n3.mat', 'fastica_result_n3', '-v7.3');
save('./data/resampled_signals/ICA_components/fastica_result_n5.mat', 'fastica_result_n5', '-v7.3');
save('./data/resampled_signals/ICA_components/fastica_result_n11.mat', 'fastica_result_n11', '-v7.3');

% mean and StD. of original data, needed for denormalization
save('./data/resampled_signals/mu_data.mat', 'mu_data', '-v7.3');
save('./data/resampled_signals/mean_data.mat', 'mean_data', '-v7.3');

%% 17.B loading ICA results - fastICA results: LOAD TO KEEP DATA CONSISTENT

% ICA components
load('./data/resampled_signals/ICA_components/fastica_result_n1'); disp("fastica_result_n1 loaded");
load('./data/resampled_signals/ICA_components/fastica_result_n2'); disp("fastica_result_n2 loaded");
load('./data/resampled_signals/ICA_components/fastica_result_n3'); disp("fastica_result_n3 loaded");
load('./data/resampled_signals/ICA_components/fastica_result_n5'); disp("fastica_result_n5 loaded");
load('./data/resampled_signals/ICA_components/fastica_result_n11'); disp("fastica_result_n11 loaded");

% mean and StD. of original data, needed for denormalization
load('./data/resampled_signals/ICA_components/mu_data.mat'); disp("original St.D. data loaded");
load('./data/resampled_signals/ICA_components/mean_data.mat'); disp("original mean data loaded");

%% 18. Removing EOG contamination from EEGs and Resetting back all non-EEG signals
% NOTE: these EOG source indices are applicable for the saved ICA 
% components only.

eog_inds = [5, 5, 7, 4, 7];
reset_s = [3, 4, 6, 8, 9];

xx_1_n1 = EOG_ICA_removal(fastica_result_n1, n1_n, eog_inds, reset_s, 1);
xx_1_n2 = EOG_ICA_removal(fastica_result_n1, n2_n, eog_inds, reset_s, 2);
xx_1_n3 = EOG_ICA_removal(fastica_result_n1, n3_n, eog_inds, reset_s, 3);
xx_1_n5 = EOG_ICA_removal(fastica_result_n1, n5_n, eog_inds, reset_s, 4);
xx_1_n11 = EOG_ICA_removal(fastica_result_n1, n11_n, eog_inds, reset_s, 5);

%% 19. Denormalizing data

n1_ef = xx_1_n1.*mean_data(1, :)' + mu_data(1, :)';
n2_ef = xx_1_n2.*mean_data(2, :)' + mu_data(2, :)';
n3_ef = xx_1_n3.*mean_data(3, :)' + mu_data(3, :)';
n5_ef = xx_1_n5.*mean_data(4, :)' + mu_data(4, :)';
n11_ef = xx_1_n11.*mean_data(5, :)' + mu_data(5, :)';

clear xx_1_n1 xx_1_n2 xx_1_n3 xx_1_n5 xx_1_n11
%% 20.A saving denormalized resampled EOG-filtered signals: SKIP TO SAVE DISK SPACE

save('./data/resampled_signals/EOG_filt/n1_ef.mat', 'n1_ef', '-v7.3');
save('./data/resampled_signals/EOG_filt/n2_ef.mat', 'n2_ef', '-v7.3');
save('./data/resampled_signals/EOG_filt/n3_ef.mat', 'n3_ef', '-v7.3');
save('./data/resampled_signals/EOG_filt/n5_ef.mat', 'n5_ef', '-v7.3');
save('./data/resampled_signals/EOG_filt/n11_ef.mat', 'n11_ef', '-v7.3');

%% 20.B loading denormalized resampled EOG-filtered signals: SKIP TO SAVE DISK SPACE

load('./data/resampled_signals/EOG_filt/n1_ef.mat');
load('./data/resampled_signals/EOG_filt/n2_ef.mat');
load('./data/resampled_signals/EOG_filt/n3_ef.mat');
load('./data/resampled_signals/EOG_filt/n5_ef.mat');
load('./data/resampled_signals/EOG_filt/n11_ef.mat');

%% 21. Comparing denormalized EOG-filtered EEGs with Raw signals
plot_1v1_EOG_artefact(n1_, n1_ef, time_vec, find(time_vec==20), "n1", selection_info);

%% Segment signals and save (SKIP TO SAVE DISK SPACE)
segmentedsignals=cell(5,9);
samplingfrequencies=512.*ones(5,9);
names={'n1_ef','n2_ef','n3_ef','n5_ef','n11_ef'}; % names of variables we are segmenting in 30s epochs
for i=1:length(names)
    patient=eval(names{i});
    for j=1:9
    segmentedsignals{i,j}=segmentsignal(patient(j,:),samplingfrequencies(i,j));
    end
end
clear i j patient names

% Synchronize with stages txt files
for i=1:9
    segmentedsignals{1,i}=segmentedsignals{1,i}(8:end-6,:);
    segmentedsignals{2,i}=segmentedsignals{2,i}(3:end,:);
    segmentedsignals{3,i}=segmentedsignals{3,i}(375:end-97,:);
    segmentedsignals{4,i}=segmentedsignals{4,i}(102:end-2,:);
    segmentedsignals{5,i}=segmentedsignals{5,i}(41:end-2,:);
end
%%
save('./Selected_dataset/segmentedsignals.mat', 'segmentedsignals', '-v7.3');
disp("segmentedsignals saved")
%% Read txt (SKIP)
% turn txts into column vector
sleepstages=cell(5,1);
for i=1:length(FileNames_txt)
    ss = txt_to_stages(FileNames_txt{i});
    sleepstages{i,1} = ss;
    disp(i+"/"+length(FileNames_txt)+" done")
end
clear i ss
save('./Selected_dataset/sleepstages.mat', 'sleepstages', '-v7.3');
disp("sleepstages saved")

%% Load segmented signals and sleepstages
load('./Selected_dataset/segmentedsignals.mat');disp("segmentedsignals loaded")
load('./Selected_dataset/sleepstages.mat');disp("sleepstages loaded")

%% Test on last patient
[P5features,P5stages]=dofeaturematrix(segmentedsignals(5,:),sleepstages(5),samplingfrequencies);
stagesfit=trainedModel.predictFcn(P5features); %prediction of stages
n=0;
for i=1:length(P5stages)
    if P5stages(i)==stagesfit(i)
        n=n+1;
    end
end

display("The algorith has an accuracy of " + n/length(P5stages)*100 +"%")
figure(4)
plot(stagesfit);hold on
plot(P5stages); hold off
title("Hypnogram real vs ML")
legend({'real','ML'},'Location','southeast')
ylim([0 5])
xlim([0 length(P5stages)])
xlabel("Epoch Number")
ylabel("Sleep Stages")
set(gca,'ytick',[0:6],'yticklabel',{'REM','','N3','N2','N1','Wake',''});

