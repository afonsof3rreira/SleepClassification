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
load('./Normal_dataset/signal_header.mat');disp("header loaded")
load('./Normal_dataset/n1.mat');disp("n1 loaded")
load('./Normal_dataset/n2.mat');disp("n2 loaded")
load('./Normal_dataset/n3.mat');disp("n3 loaded")
load('./Normal_dataset/n5.mat');disp("n5 loaded")
load('./Normal_dataset/n11.mat');disp("n11 loaded")

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

samplingfrequencies=zeros(1,length(common_labs));
for i=1:length(common_labs)
    j=1;
    while j<length(signal_header{1}.label)
        if signal_header{1}.label(j)==common_labs(i)
            samplingfrequencies(i)=signal_header{1}.samples(j);
        end
        j=j+1;
    end
end
selection_info = [common_labs; common_transds;samplingfrequencies];

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

load('./Selected_dataset/selection_info.mat');disp("selected info loaded")
load('./Selected_dataset/signal_header.mat');disp("header loaded")
load('./Selected_dataset/n1.mat');disp("n1 loaded")
load('./Selected_dataset/n2.mat');disp("n2 loaded")
load('./Selected_dataset/n3.mat');disp("n3 loaded")
load('./Selected_dataset/n5.mat');disp("n5 loaded")
load('./Selected_dataset/n11.mat');disp("n11 loaded")

%% plotting signals

X = n1;
X = zscore(X');X=X'; % mean => 0, St.D. => 1

% figure()
% plot(n1(1, :));
% hold on;
% plot(X(1, :));
% hold off;

% --- comment / uncomment
[Xe, A, W] = fastica (X);
fastica_result = struct;
fastica_result.Xe_n1 = Xe;
fastica_result.A_n1 = A;
fastica_result.W_n1 = W;
save('fastica_result_n1.mat','-struct','fastica_result');
% clear fastica_result Xe A W;
% --- comment / uncomment
% load('fastica_result.mat');
% --- comment / uncomment

%%

figure();
artefact_color_1 = [0.8500 0.3250 0.0980];
artefact_color_2 = [0.4660 0.6740 0.1880];

c1 = 1;
c2 = 2;
comp_remove = [1, 2, 9];

for i = 1 : size(X, 1)
    yls = max(X(i, :)); % y lim superior
    yli = min(X(i, :)); % y lim inferior
    subplot(size(X, 1), 2, c1)
    plot(X(i, :));
    ylim([-4 yls + 0.25*yls]);
    grid on; grid minor;
    if i == 1
        title("Original signal X");
    end
%     ylabel(transd_labels(i), 'fontweight','bold');
    
    subplot(size(X, 1), 2, c2)
    if i == comp_remove(1, 1) || i == comp_remove(1, 2) || i == comp_remove(1, 3)
        plot(Xe(i, :), 'Color', artefact_color_1);       
    else
        plot(Xe(i, :));
    end
    grid on; grid minor;
    if i == 1
        title("ICA components: EOG artefact-rich components in orange");
    end
    ica_label = "Comp.";
    ylabel(strcat(ica_label, int2str(i)), 'fontweight','bold');
    ylim([-4 yls + 0.25*yls]);
    c1 = c1 + 2;
    c2 = c2 + 2;
end


%% Read txt
% turn txts into column vector
sleepstages=[];
for i=1:length(FileNames_txt)
    ss = txt_to_stages(FileNames_txt{i});
    sleepstages = [sleepstages;ss];
    disp(i+"/"+length(FileNames_txt)+" done")
end
