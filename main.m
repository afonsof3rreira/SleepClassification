%% PDSB Project

clear
close all
warning('off','all')
% save edf files and txt files in separate directories as below
Files_edf = dir('./Files_edf');
Files_txt = dir('./Files_txt');

i=1;
for k=1:length(Files_edf)
    if Files_edf(k).bytes>10000
        FileNames_edf{i}=(Files_edf(k).name);i=i+1;
    end
end

i=1;
for k=1:length(Files_txt)
    if Files_txt(k).bytes>10000
        FileNames_txt{i}=(Files_txt(k).name);i=i+1;
    end
end

%% Get channels and header
signal=cell(5,1);
signal_header=cell(5,1);
for i=1:length(FileNames_edf)
    [header,channels]=edfread(FileNames_edf{i});
    disp("file "+i+" of 5 done")
    signal{i}=channels;
    signal_header{i}=header;
end

%% Save header and signals

save('./Normal_dataset/signal_header.mat','signal_header')
disp("header saved")
n1 = signal{1};
save('./Normal_dataset/n1.mat', 'n1', '-v7.3')
disp("n1 saved")
n2 = signal{2};
save('./Normal_dataset/n2.mat', 'n2', '-v7.3')
disp("n2 saved")
n3 = signal{3};
save('./Normal_dataset/n3.mat', 'n3', '-v7.3')
disp("n3 saved")
n5 = signal{4};
save('./Normal_dataset/n5.mat', 'n5', '-v7.3')
disp("n5 saved")
n11 = signal{5};
save('./Normal_dataset/n11.mat', 'n11', '-v7.3')
disp("n11 saved")

%% Load signals
clear all
load('./Normal_dataset/signal_header.mat')
load('./Normal_dataset/n1.mat')
load('./Normal_dataset/n2.mat')
load('./Normal_dataset/n3.mat')
load('./Normal_dataset/n5.mat')
load('./Normal_dataset/n11.mat')

%% checking all available different signals for a given signal header

[labels, transducers] = check_all_avail_signals(signal_header);
labels = deblank(labels);
transducers = deblank(transducers);

%% Selecting signals types common to all patients / datasets

[common_labs, common_transds] = check_common_signals(signal_header);

[~, ~, ib] = intersect(common_labs, signal_header{1, 1}.label);
n1 = n1(ib(:), :);

[~, ~, ib] = intersect(common_labs, signal_header{2, 1}.label);
n2 = n2(ib(:), :);

[~, ~, ib] = intersect(common_labs, signal_header{3, 1}.label);
n3 = n3(ib(:), :);

[~, ~, ib] = intersect(common_labs, signal_header{4, 1}.label);
n5 = n5(ib(:), :);

[~, ~, ib] = intersect(common_labs, signal_header{5, 1}.label);
n11 = n11(ib(:), :);

clear ib;

selection_info = [common_labs; common_transds];
save('./Selected_dataset/selection_info.mat','selection_info')
disp("selected info saved")

save('./Selected_dataset/signal_header.mat','signal_header')
disp("header saved")

save('./Selected_dataset/n1.mat', 'n1', '-v7.3')
disp("n1 saved")

save('./Selected_dataset/n2.mat', 'n2', '-v7.3')
disp("n2 saved")

save('./Selected_dataset/n3.mat', 'n3', '-v7.3')
disp("n3 saved")

save('./Selected_dataset/n5.mat', 'n5', '-v7.3')
disp("n5 saved")

save('./Selected_dataset/n11.mat', 'n11', '-v7.3')
disp("n11 saved")

%% Load selected signals
clear all
load('./Selected_dataset/common_labels.mat')
load('./Selected_dataset/signal_header.mat')
load('./Selected_dataset/n1.mat')
load('./Selected_dataset/n2.mat')
load('./Selected_dataset/n3.mat')
load('./Selected_dataset/n5.mat')
load('./Selected_dataset/n11.mat')
%% Read txt
% turn txts into column vector
sleepstages=[];
for i=1:length(FileNames_txt)
    ss = txt_to_stages(FileNames_txt{i});
    sleepstages = [sleepstages;ss];
    disp(i+"/"+length(FileNames_txt)+" done")
end

