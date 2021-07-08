%% TRAINING MODEL COMPARISON (Used for the papper)
% This script was used to generate a plot to allow comparing different
% trained models obtained in the pipeline.

%% 1. loading trained models

disp("loading mat files...");
load('./data/training_models/trainedModelICA.mat'); disp("ICA model loaded");
load('./data/ground_truth/sleepstages.mat'); disp("sleep stages loaded");
load('./data/segmented_signals/segmentedsignals.mat'); disp("segmented signals loaded");
load('./data/raw_data/mat_files/samplingfrequencies.mat'); disp("sampling frequencies loaded");

%% 2. Classifying testing data (patient/signal n5) using a pre-trained model
% computing feature matrix
[P5features,P5stages]=dofeaturematrix(segmentedsignals(5,:),sleepstages(5),samplingfrequencies);

% classifying
model = trainedModelICA.ClassificationSVM;
[labels, score, ~] = predict(model, P5features);

% convert log posterior class probabilities to [0-1]
score = exp(score);
%% 3.A Plotting a boxplot using data chunks of predictors

chunk_size = 20;
chunk_sample_size = floor(size(P5stages, 1) / chunk_size);
confusion_arr = zeros(chunk_sample_size, 1);

for i = 1: chunk_sample_size
    start_ind = i*chunk_size - chunk_size + 1;
    end_ind = i*chunk_size;
    confusion_arr(i, 1) = sum(P5stages(start_ind:end_ind,1) == labels(start_ind:end_ind,1))/chunk_size;
end

boxplot(confusion_arr, 'Notch','on', 'Whisker',1);
hold on
scatter(ones(size(confusion_arr)).*(1+(rand(size(confusion_arr))-0.5)/10),confusion_arr,'r','filled');

%% 3.A Plotting a boxplot using class scores


n_classes = size(score, 2);
gt_s1 = zeros(1, sum(P5stages == 1));
gt_s2 = zeros(1, sum(P5stages == 2));
gt_s3 = zeros(1, sum(P5stages == 3));
gt_s4 = zeros(1, sum(P5stages == 4));
gt_s5 = zeros(1, sum(P5stages == 5));
gt_s6 = zeros(1, sum(P5stages == 6));

ind_gt_s1 = find(P5stages == 1);
ind_gt_s2 = find(P5stages == 2);
ind_gt_s3 = find(P5stages == 3);
ind_gt_s4 = find(P5stages == 4);
ind_gt_s5 = find(P5stages == 5);
ind_gt_s6 = find(P5stages == 6);

scores_s1 = score(ind_gt_s1, 1);
scores_s2 = score(ind_gt_s2, 1);
scores_s3 = score(ind_gt_s3, 1);
scores_s4 = score(ind_gt_s4, 1);
scores_s5 = score(ind_gt_s5, 1);
scores_s6 = score(ind_gt_s6, 1);

g = [zeros(length(scores_s1), 1); ones(length(scores_s2), 1);...
     2*ones(length(scores_s3), 1); 3*ones(length(scores_s4), 1);...
     4*ones(length(scores_s5), 1); 5*ones(length(scores_s6), 1)];

boxplot([scores_s1; scores_s2; scores_s3; scores_s4; scores_s5; scores_s6],...
        g, 'Notch','on', 'Whisker',1,...
        'Labels',{'S1', 'S2', 'S3', 'S4', 'S5', 'S6'});
    
title('Class probability distribution of testing signal (n11) epochs','interpreter','latex','FontUnits','points',...
    'FontWeight','demi','FontSize',18,'FontName','Times');

xlabel('sleep stages','interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',12,'FontName','Times');

ylabel('class probabilities','interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',12,'FontName','Times');

%%

s1_ind = find(P5stages == 1);
s2_ind = find(P5stages == 2);
s3_ind = find(P5stages == 3);
s4_ind = find(P5stages == 4);
s5_ind = find(P5stages == 5);
s6_ind = find(P5stages == 6);

confusion_result(1, 1) = sum(labels(s1_ind, 1) == 1) / length(labels(s1_ind, 1));
confusion_result(2, 1) = sum(labels(s2_ind, 1) == 2) / length(labels(s2_ind, 1));
confusion_result(3, 1) = sum(labels(s3_ind, 1) == 3) / length(labels(s3_ind, 1));
confusion_result(4, 1) = sum(labels(s4_ind, 1) == 4) / length(labels(s4_ind, 1));
confusion_result(5, 1) = sum(labels(s5_ind, 1) == 5) / length(labels(s5_ind, 1));
confusion_result(6, 1) = sum(labels(s6_ind, 1) == 6) / length(labels(s6_ind, 1));

