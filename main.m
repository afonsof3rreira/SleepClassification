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
save('.\Normal_dataset\signal_header.mat','signal_header')

n1 = signal{1};
save('.\Normal_dataset\n1.mat', 'n1', '-v7.3')
n2 = signal{2};
save('.\Normal_dataset\n2.mat', 'n2', '-v7.3')
n3 = signal{3};
save('.\Normal_dataset\n3.mat', 'n3', '-v7.3')
n5 = signal{4};
save('.\Normal_dataset\n5.mat', 'n5', '-v7.3')
n11 = signal{5};
save('.\Normal_dataset\n11.mat', 'n11', '-v7.3')

%% Load signals
clear all
load('.\Normal_dataset\signal_header.mat')
load('.\Normal_dataset\n1.mat')
load('.\Normal_dataset\n2.mat')
load('.\Normal_dataset\n3.mat')
load('.\Normal_dataset\n5.mat')
load('.\Normal_dataset\n11.mat')

%% Read txt
% turn txts into column vector
sleepstages=[];
for i=1:length(FileNames_txt)
    ss = txt_to_stages(FileNames_txt{i});
    sleepstages = [sleepstages;ss];
    disp(i+"/"+length(FileNames_txt)+" done")
end










