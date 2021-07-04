%% PDSB Project

clear
close all
warning('off','all')
%%
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
clear i k
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

save('./Selected_dataset/samplingfrequencies.mat','samplingfrequencies')
disp("sampling frequencies saved")

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

load('./Selected_dataset/selection_info.mat');disp("selected info loaded")
load('./Selected_dataset/samplingfrequencies.mat');disp("sfs loaded")
load('./Selected_dataset/signal_header.mat');disp("header loaded")
load('./Selected_dataset/n1.mat');disp("n1 loaded")
load('./Selected_dataset/n2.mat');disp("n2 loaded")
load('./Selected_dataset/n3.mat');disp("n3 loaded")
load('./Selected_dataset/n5.mat');disp("n5 loaded")
load('./Selected_dataset/n11.mat');disp("n11 loaded")

%% Segment signals
segmentedsignals=cell(5,9);
names={'n1','n2','n3','n5','n11'}; % names of variables we are segmenting in 30s epochs
for i=1:length(names)
    patient=eval(names{i});
    for j=1:9
    segmentedsignals{i,j}=segmentsignal(patient(j,:),samplingfrequencies(i,j));
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
save('./Selected_dataset/segmentedsignals.mat', 'segmentedsignals', '-v7.3');
disp("segmentedsignals saved")
%% Read txt
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

%%

time_mat = {};

for i = 1: length(signal_header)
    n_records = signal_header{i, 1}.records;
    n_duration = signal_header{i, 1}.duration;
    tot_duration = n_records * n_duration;
    disp(n_records);
    vals = {};
    for j = 1 : size(n1, 1)
        sf = signal_header{i, 1}.samples(1, ib(i, j));
        ts = 1 / sf; %  str2num(selection_info(3, j));
        vals{j, 1} = 0: ts: tot_duration - ts;
    end
    time_mat{i, 1} = vals;
end


%% plotting signals

whole_sample = false;

signal_name = "";
for i = 1:5
    sub_time_mat = time_mat{i, 1};
    switch i
        case 1
            var = n1;
            signal_name = "n1";
        case 2
            var = n2;
            signal_name = "n2";
        case 3 
            var = n3;
            signal_name = "n3";
        case 4
            var = n5;
            signal_name = "n5";
        case 5
            var = n11;
            signal_name = "n11";
    end
    figure();
    for j = 1: 9
        time_vec = sub_time_mat{j, 1};
        subplot(9, 1, j);
        
        if whole_sample
            time_cropped = size(time_vec, 2);
        else
            end_time = 20; % in seconds
            time_cropped = find(time_vec==20);
        end
   
        signal = var(j, 1:time_cropped);
        plot(time_vec(1:time_cropped), signal);

        title(selection_info(1, j) + " " + num2str(1/time_vec(2)));
    end
    sgtitle("Signal " + signal_name);
    xlabel("time [s]");
end

%% Checking which signals to upsample
max_sfs = check_s_freqs(ib, signal_header);

%% Upsampling
clearvars -except ib signal_header n1 n2 n3 n5 n11 max_sfs time_mat selection_info

n1_ = zeros(size(n1, 1), size(n1, 2));
n2_ = zeros(size(n2, 1), size(n2, 2));
n3_ = zeros(size(n3, 1), size(n3, 2));
n5_ = zeros(size(n5, 1), size(n5, 2));
n11_ = zeros(size(n11, 1), size(n11, 2));


for i = 1: size(ib, 1)
    disp(i);
    for j = 1: size(ib, 2)
        if signal_header{i, 1}.samples(ib(i, j)) ~= max_sfs(i)
            disp(signal_header{i, 1}.label(ib(i, j)));
            sf = max_sfs(i);
            len = size(time_mat{i, 1}{j, 1}, 2);
            factor = sf/signal_header{i, 1}.samples(ib(i, j));
            switch i
                case 1
                    n1_(j, :) = resample(n1(j, 1:len), factor, 1);
                case 2
                    n2_(j, :) = resample(n2(j, 1:len), factor, 1);
                case 3 
                    n3_(j, :) = resample(n3(j, 1:len), factor, 1);
                case 4
                    n5_(j, :) = resample(n5(j, 1:len), factor, 1);
                case 5
                    n11_(j, :) = resample(n11(j, 1:len), factor, 1);
            end
        else
            switch i
                case 1
                    n1_(j, :) = n1(j, :);
                case 2
                    n2_(j, :) = n2(j, :);
                case 3 
                    n3_(j, :) = n3(j, :);
                case 4
                    n5_(j, :) = n5(j, :);
                case 5
                    n11_(j, :) = n11(j, :);
            end
        end
    end
end

%% plotting signals (2.0)

whole_sample = false;
scatter = false;

signal_name = "";
for i = 1:5
    sub_time_mat = time_mat{i, 1};
    switch i
        case 1
            var = n1;
            var_ = n1_;
            signal_name = "n1";
        case 2
            var = n2;
            var_ = n2_;
            signal_name = "n2";
        case 3
            var = n3;   
            var_ = n3_;
            signal_name = "n3";
        case 4
            var = n5;   
            var_ = n5_;
            signal_name = "n5";
        case 5
            var = n11;   
            var_ = n11_;
            signal_name = "n11";
    end
    figure(); 
    for j = 1: 9
        time_vec_res = sub_time_mat{1, 1};
        time_vec = sub_time_mat{j, 1};
        ax(j) = subplot(9, 1, j);
        
        if whole_sample
            time_cropped = size(time_vec_res, 2);
        else
            end_time = 20; % in seconds
            time_cropped_ = find(time_vec_res==20);
            time_cropped = find(time_vec==20);
        end
   
        signal_ = var_(j, 1:time_cropped_);
        signal = var(j, 1:time_cropped);
        if scatter
            scatter(time_vec_res(1:time_cropped_), signal_); hold on;
            scatter(time_vec(1:time_cropped), signal); hold off;
        else
            plot(time_vec_res(1:time_cropped_), signal_); hold on;
            plot(time_vec(1:time_cropped), signal); hold off;
        end
        title(selection_info(1, j) + " " + num2str(1/time_vec(2)));
    end
    linkaxes(ax(:));
    sgtitle("Signal " + signal_name);
    xlabel("time [s]");
    clear ax
end


%% saving resampled signals

disp("...saving resampled data");

time_vec = time_mat{1, 1}{1, 1};

save('./Resampled_dataset/signal_header.mat','signal_header')
disp("header saved")

save('./Resampled_dataset/time_vec.mat','time_vec')
disp("time saved")

save('./Resampled_dataset/n1.mat', 'n1_', '-v7.3')
disp("n1 saved")

save('./Resampled_dataset/n2.mat', 'n2_', '-v7.3')
disp("n2 saved")

save('./Resampled_dataset/n3.mat', 'n3_', '-v7.3')
disp("n3 saved")

save('./Resampled_dataset/n5.mat', 'n5_', '-v7.3')
disp("n5 saved")

save('./Resampled_dataset/n11.mat', 'n11_', '-v7.3')
disp("n11 saved")

%% Load resampled signals
clear 
load('./Resampled_dataset/signal_header.mat');disp("signal header loaded")
load('./Selected_dataset/selected_indices.mat');disp("signal selection loaded")
load('./Selected_dataset/selection_info.mat');disp("signal info loaded")
load('./Resampled_dataset/time_vec.mat');disp("time vector loaded")
load('./Resampled_dataset/n1.mat');disp("n1 loaded")
load('./Resampled_dataset/n2.mat');disp("n2 loaded")
load('./Resampled_dataset/n3.mat');disp("n3 loaded")
load('./Resampled_dataset/n5.mat');disp("n5 loaded")
load('./Resampled_dataset/n11.mat');disp("n11 loaded")

%% trying ICA

clearvars -except n1_ n2_ n3_ n5_ n11_ time_vec signal_header selected_indices selection_info


for i = 1: 5
    switch i
        case 1
            var_ = n1_;
            signal_name = "n1";
        case 2
            var_ = n2_;
            signal_name = "n2";
        case 3
            var_ = n3_;
            signal_name = "n3";
        case 4
            var_ = n5_;
            signal_name = "n5";
        case 5
            var_ = n11_;
            signal_name = "n11";
    end
    X = var_;
    X = zscore(X');
    X=X'; % mean => 0, St.D. => 1
    [Xe, A, W] = fastica (X);
    switch i
        case 1
            n1_n = X;
            fastica_result_n1 = struct;
            fastica_result_n1.Xe_n1 = Xe;
            fastica_result_n1.A_n1 = A;
            fastica_result_n1.W_n1 = W;
        case 2
            n2_n = X;
            fastica_result_n2 = struct;
            fastica_result_n2.Xe_n2 = Xe;
            fastica_result_n2.A_n2 = A;
            fastica_result_n2.W_n2 = W;
        case 3
            n3_n = X;
            fastica_result_n3 = struct;
            fastica_result_n3.Xe_n3 = Xe;
            fastica_result_n3.A_n3 = A;
            fastica_result_n3.W_n3 = W;
        case 4
            n5_n = X;
            fastica_result_n5 = struct;
            fastica_result_n5.Xe_n5 = Xe;
            fastica_result_n5.A_n5 = A;
            fastica_result_n5.W_n5 = W;
        case 5
            n11_n = X;
            fastica_result_n11 = struct;
            fastica_result_n11.Xe_n11 = Xe;
            fastica_result_n11.A_n11 = A;
            fastica_result_n11.W_n11 = W;
    end
end

% save('./ICA_components/n1_n.mat', 'n1_n', '-v7.3');
% save('./ICA_components/n2_n.mat', 'n2_n', '-v7.3');
% save('./ICA_components/n3_n.mat', 'n3_n', '-v7.3');
% save('./ICA_components/n5_n.mat', 'n5_n', '-v7.3');
% save('./ICA_components/n11_n.mat', 'n11_n', '-v7.3');
% 
% save('./ICA_components/fastica_result_n1.mat', 'fastica_result_n1', '-v7.3');
% save('./ICA_components/fastica_result_n2.mat', 'fastica_result_n2', '-v7.3');
% save('./ICA_components/fastica_result_n3.mat', 'fastica_result_n3', '-v7.3');
% save('./ICA_components/fastica_result_n5.mat', 'fastica_result_n5', '-v7.3');
% save('./ICA_components/fastica_result_n11.mat', 'fastica_result_n11', '-v7.3');

for i = 1: 5
    switch i
        case 1
            X = n1_;
            X = zscore(X');
            n1_n = X';
        case 2
            X = n2_;
            X = zscore(X');
            n2_n = X';
        case 3
            X = n3_;
            X = zscore(X');
            n3_n = X';
        case 4
            X = n5_;
            X = zscore(X');
            n5_n = X';
        case 5
            X = n11_;
            X = zscore(X');
            n11_n = X';
    end

end

save('./Resampled_normalized_dataset/n1_n.mat', 'n1_n', '-v7.3');
save('./Resampled_normalized_dataset/n2_n.mat', 'n2_n', '-v7.3');
save('./Resampled_normalized_dataset/n3_n.mat', 'n3_n', '-v7.3');
save('./Resampled_normalized_dataset/n5_n.mat', 'n5_n', '-v7.3');
save('./Resampled_normalized_dataset/n11_n.mat', 'n11_n', '-v7.3');

%%

load('./ICA_components/fastica_result_n1'); disp("fastica_result_n1 loaded");
load('./ICA_components/fastica_result_n2'); disp("fastica_result_n2 loaded");
load('./ICA_components/fastica_result_n3'); disp("fastica_result_n3 loaded");
load('./ICA_components/fastica_result_n5'); disp("fastica_result_n5 loaded");
load('./ICA_components/fastica_result_n11'); disp("fastica_result_n11 loaded");

load('./Resampled_normalized_dataset/n1_n.mat'); disp("n1_n loaded");
load('./Resampled_normalized_dataset/n2_n.mat'); disp("n2_n loaded");
load('./Resampled_normalized_dataset/n3_n.mat'); disp("n3_n loaded");
load('./Resampled_normalized_dataset/n5_n.mat'); disp("n5_n loaded");
load('./Resampled_normalized_dataset/n11_n.mat'); disp("n11_n loaded");

%%
last_t_ind = find(time_vec==20);
emg_inds = [3, 2, 3, 5, 4;...
            4, 1, 4, 2, 1]';
eog_inds = [5, 5, 7, 4, 7];

artefact_color_1 = [0.8500 0.3250 0.0980];
artefact_color_2 = [0.4660 0.6740 0.1880];
artefact_color_3 = [0.4940, 0.1840, 0.5560];


for j = 1: 5
    switch j
        case 1
            Xe = fastica_result_n1.Xe_n1;
            X = n1_n;
            signal_name = "n1";
        case 2
            Xe = fastica_result_n2.Xe_n2;
            X = n2_n;
            signal_name = "n2";
        case 3
            Xe = fastica_result_n3.Xe_n3;
            X = n3_n;
            signal_name = "n3";
        case 4
            Xe = fastica_result_n5.Xe_n5;
            X = n5_n;
            signal_name = "n5";
        case 5
            Xe = fastica_result_n11.Xe_n11;
            X = n11_n;
            signal_name = "n11";
    end
    
    figure();
    sgtitle(signal_name);

    c1 = 1;
    c2 = 2;
    ax_1 = gobjects(3,1);
    ax_2 = gobjects(3,1);
    
    for i = 1 : size(X, 1)

        ax_1(i) = subplot(size(X, 1), 2, c1);
        
        if i == 4
            plot(time_vec(1:last_t_ind), X(i, 1:last_t_ind), 'Color', artefact_color_1);
            
        elseif i == 9
            plot(time_vec(1:last_t_ind), X(i, 1:last_t_ind), 'Color', artefact_color_2);
        elseif i == 8
            plot(time_vec(1:last_t_ind), X(i, 1:last_t_ind), 'Color', artefact_color_3);
        else
            plot(time_vec(1:last_t_ind), X(i, 1:last_t_ind));
        end
        
        grid on; grid minor;
        title(selection_info(2, i));

        ax_2(i) = subplot(size(X, 1), 2, c2);
        
        if emg_inds(j, 1) == i
            plot(time_vec(1:last_t_ind), Xe(i, 1:last_t_ind), 'Color', artefact_color_1);
            
        elseif emg_inds(j, 2) == i
            plot(time_vec(1:last_t_ind), Xe(i, 1:last_t_ind), 'Color', artefact_color_2);
            
        elseif eog_inds(1, j) == i
            plot(time_vec(1:last_t_ind), Xe(i, 1:last_t_ind), 'Color', artefact_color_3);
        else
            plot(time_vec(1:last_t_ind), Xe(i, 1:last_t_ind));
        end
        grid on; grid minor;
        if i == 1
            title("ICA components: marked = orange");
        end
        ica_label = "C.";
        ylabel(strcat(ica_label, int2str(i)), 'fontweight','bold');
        
        c1 = c1 + 2;
        c2 = c2 + 2;
        linkaxes([ax_1 ax_2], 'x');
    end
    clear ax_1 ax_2

end

%%
emg_inds = [3, 2, 3, 5, 4;...
            4, 1, 4, 2, 1]';
eog_inds = [5, 5, 7, 4, 7];
ecg_inds = [8, 4, 6, 7, 6];
        
G_1_n1 = fastica_result_n1.A_n1;
G_1_n1(:, eog_inds(1, 1)) = 0; % (3)
xx_1_n1 = G_1_n1*fastica_result_n1.Xe_n1;

G_1_n2 = inv(fastica_result_n2.W_n2);
G_1_n2(:, eog_inds(1, 2)) = 0; % (3)
xx_1_n2 = G_1_n2*fastica_result_n2.Xe_n2;

G_1_n3 = inv(fastica_result_n3.W_n3);
G_1_n3(:, eog_inds(1, 3)) = 0; % (3)
xx_1_n3 = G_1_n3*fastica_result_n3.Xe_n3;

G_1_n5 = inv(fastica_result_n5.W_n5);
G_1_n5(:, eog_inds(1, 4)) = 0; % (3)
xx_1_n5 = G_1_n5*fastica_result_n5.Xe_n5;

G_1_n11 = inv(fastica_result_n11.W_n11);
G_1_n11(:, eog_inds(1, 5)) = 0; % (3)
xx_1_n11 = G_1_n11*fastica_result_n11.Xe_n11;

%%

reset_s = [3, 4, 6, 8, 9];

xx_1_n1(reset_s(:), :) = n1_n(reset_s(:), :);
xx_1_n2(reset_s(:), :) = n2_n(reset_s(:), :);
xx_1_n3(reset_s(:), :) = n3_n(reset_s(:), :);
xx_1_n5(reset_s(:), :) = n5_n(reset_s(:), :);
xx_1_n11(reset_s(:), :) = n11_n(reset_s(:), :);



%%
save('./Resampled_normalized_dataset_post_ICA_EOG/xx_1_n1.mat', 'xx_1_n1', '-v7.3');
save('./Resampled_normalized_dataset_post_ICA_EOG/xx_1_n2.mat', 'xx_1_n2', '-v7.3');
save('./Resampled_normalized_dataset_post_ICA_EOG/xx_1_n3.mat', 'xx_1_n3', '-v7.3');
save('./Resampled_normalized_dataset_post_ICA_EOG/xx_1_n5.mat', 'xx_1_n5', '-v7.3');
save('./Resampled_normalized_dataset_post_ICA_EOG/xx_1_n11.mat', 'xx_1_n11', '-v7.3');


%%
artefact_color_1 = [0.8500 0.3250 0.0980];
artefact_color_2 = [0.4660 0.6740 0.1880];
artefact_color_3 = [0.4940, 0.1840, 0.5560];

for j = 1: 5
    switch j
        case 1
            xx = xx_1_n1;
            X = n1_n;
            signal_name = "n1";
        case 2
            xx = xx_1_n2;
            X = n2_n;
            signal_name = "n2";
        case 3
            xx = xx_1_n3;
            X = n3_n;
            signal_name = "n3";
        case 4
            xx = xx_1_n5;
            X = n5_n;
            signal_name = "n5";
        case 5
            xx = xx_1_n11;
            X = n11_n;
            signal_name = "n11";
    end
    
    figure();
    sgtitle(signal_name);

    c1 = 1;
    c2 = 2;
    ax_1 = gobjects(3,1);
    ax_2 = gobjects(3,1);
    
    for i = 1 : size(X, 1)

        ax_1(i) = subplot(size(X, 1), 2, c1);
        
        if i == 4
            plot(time_vec(1:last_t_ind), X(i, 1:last_t_ind), 'Color', artefact_color_1);
            
        elseif i == 9
            plot(time_vec(1:last_t_ind), X(i, 1:last_t_ind), 'Color', artefact_color_2);
            
        elseif i == 8
            plot(time_vec(1:last_t_ind), X(i, 1:last_t_ind), 'Color', artefact_color_3);
            
        else
            plot(time_vec(1:last_t_ind), X(i, 1:last_t_ind));
        end
        
        grid on; grid minor;
        title(selection_info(2, i));

        ax_2(i) = subplot(size(X, 1), 2, c2);
        
        if i == 4
            plot(time_vec(1:last_t_ind), xx(i, 1:last_t_ind), 'Color', artefact_color_1);
            
        elseif i == 9
            plot(time_vec(1:last_t_ind), xx(i, 1:last_t_ind), 'Color', artefact_color_2);
            
        elseif i == 8
            plot(time_vec(1:last_t_ind), xx(i, 1:last_t_ind), 'Color', artefact_color_3);
            
        else
            plot(time_vec(1:last_t_ind), xx(i, 1:last_t_ind));
        end
        
        grid on; grid minor;
        if i == 1
            title("ICA components: marked = orange");
        end
        ica_label = "C.";
        ylabel(strcat(ica_label, int2str(i)), 'fontweight','bold');
        
        c1 = c1 + 2;
        c2 = c2 + 2;
        linkaxes([ax_1 ax_2], 'x');
    end
    clear ax_1 ax_2

end

%%
last_t_ind = find(time_vec==20);

for j = 1: 5
    switch j
        case 1
            xx = xx_1_n1;
            X = n1_n;
            signal_name = "n1";
        case 2
            xx = xx_1_n2;
            X = n2_n;
            signal_name = "n2";
        case 3
            xx = xx_1_n3;
            X = n3_n;
            signal_name = "n3";
        case 4
            xx = xx_1_n5;
            X = n5_n;
            signal_name = "n5";
        case 5
            xx = xx_1_n11;
            X = n11_n;
            signal_name = "n11";
    end
    
    figure();
    sgtitle(signal_name);

    c1 = 1;
    c2 = 2;
    ax_1 = gobjects(3,1);
    ax_2 = gobjects(3,1);
    
    for i = 1 : 9

        ax_1(i) = subplot(size(X, 1), 1, i);
        plot(time_vec(1:last_t_ind), X(i, 1:last_t_ind)); hold on;
        plot(time_vec(1:last_t_ind), xx(i, 1:last_t_ind)); hold off;


        linkaxes([ax_1], 'x');
    end
    clear ax_1 ax_2

end


