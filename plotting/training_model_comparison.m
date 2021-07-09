%% TRAINING MODEL COMPARISON (Used for the papper)
% This script was used to generate a plot to allow comparing different
% trained models obtained in the pipeline.

%% 1. loading trained models
mode = input('Do you want to retreive all preprocessed signals? (Y/N): ', 's');
str_vec_model = {'trainedModelraw', 'trainedModelICA', 'trainedModelnoICA', 'trainedModelICAfilt'};
str_test = {'P5features_raw', 'P5features_ICA', 'P5features_noICA', 'P5features_ICAfilt'};

if mode == 'Y' || mode == 'y'

    model_cell = cell(4, 1);
    test_cell = cell(4, 1);    
    
    for i = 1:4
        disp(strcat("loading mat files for ", string(str_vec_model{1, i}(1, 13:end)), "-preprocessed data..."));

        trainedModel = load(strcat('./data/training_models/', str_vec_model{1, i}, '.mat')); disp("trained model loaded");
        P5features = load(strcat('./data/testing_data/', str_test{1, i}, '.mat')); disp("testing data features loaded");
        assignin('base', 'trainedModel', trainedModel.(str_vec_model{1, i}));
        assignin('base', 'P5features', P5features.(str_test{1, i}));
        model_cell{i, 1} = trainedModel;
        test_cell{i, 1} = P5features;
        clear trainedModel P5features
        
    end

elseif mode == 'N' || mode == 'n' 
    
    prep_ind = input('Pick a preprocessing combination index from 1 to 4: ');
    
    model_cell = cell(1, 1);
    test_cell = cell(1, 1);  
    
    disp(strcat("loading mat files for ", string(str_vec_model(13:end)), "-preprocessed data..."));

    trainedModel = load(strcat('./data/training_models/', str_vec_model{1, prep_ind}, '.mat')); disp("trained model loaded");
    P5features = load(strcat('./data/testing_data/', str_test{1, prep_ind}, '.mat')); disp("testing data features loaded");
    assignin('base', 'trainedModel', trainedModel.(str_vec_model{1, prep_ind}));
    assignin('base', 'P5features', P5features.(str_test{1, prep_ind}));
    model_cell{1, 1} = trainedModel;
    test_cell{1, 1} = P5features;
end

stages_mat = load('./data/ground_truth/sleepstages.mat'); disp("ground truth loaded");
clear trainedModel P5features

%% 2. Classifying testing data (patient/signal n11) using a pre-trained model

% retreiving ground-truth for the testing signal
disp("retreiving ground-truth of the testing signal...");
P5stages = stages_mat.sleepstages{5, 1};

if mode == 'Y' || mode == 'y'

    label_cell = cell(4, 1);
    score_cell = cell(4, 1);

    % classifying
    disp("classifying testing data...");
    for i = 1: 4
        [label_cell{i, 1}, score, ~] = predict(model_cell{i, 1}.ClassificationSVM,...
                                                          test_cell{i, 1});

        % convert log posterior class probabilities to [0-1]
        score_cell{i, 1} = exp(score);
    end
    
elseif mode == 'N' || mode == 'n'

    label_cell = cell(1, 1);
    score_cell = cell(1, 1);

    % classifying
    disp("classifying testing data...");
    [label_cell{1, 1}, score, ~] = predict(model_cell{1, 1}.ClassificationSVM,...
                                           test_cell{1, 1});

    % convert log posterior class probabilities to [0-1]
    score_cell{1, 1} = exp(score);
    
end


%% 3. Plotting a boxplot using class scores

overlap_scatter = input('Do you want to overalp scattered data points on the boxplots? (Y/N): ', 's');

prep_labels = ["No Preprocessing", "ICA", "Filtering", "ICA $+$ Filtering"];

if mode == 'Y' || mode == 'y'


    for i = 1:4
        score = score_cell{i, 1};

        n_classes = size(score, 2);
        gt_s1 = zeros(1, sum(P5stages == 5));
        gt_s2 = zeros(1, sum(P5stages == 4));
        gt_s3 = zeros(1, sum(P5stages == 3));
        gt_s4 = zeros(1, sum(P5stages == 2));
        gt_s5 = zeros(1, sum(P5stages == 1));
        gt_s6 = zeros(1, sum(P5stages == 0));

        ind_gt_s1 = find(P5stages == 5);
        ind_gt_s2 = find(P5stages == 4);
        ind_gt_s3 = find(P5stages == 3);
        ind_gt_s4 = find(P5stages == 2);
        ind_gt_s5 = find(P5stages == 1);
        ind_gt_s6 = find(P5stages == 0);

        scores_s1 = score(ind_gt_s1, 1);
        scores_s2 = score(ind_gt_s2, 1);
        scores_s3 = score(ind_gt_s3, 1);
        scores_s4 = score(ind_gt_s4, 1);
        scores_s5 = score(ind_gt_s5, 1);
        scores_s6 = score(ind_gt_s6, 1);

        g = [zeros(length(scores_s1), 1); ones(length(scores_s2), 1);...
             2*ones(length(scores_s3), 1); 3*ones(length(scores_s4), 1);...
             4*ones(length(scores_s5), 1); 5*ones(length(scores_s6), 1)];

        figure();
        boxplot([scores_s1; scores_s2; scores_s3; scores_s4; scores_s5; scores_s6],...
                g, 'Notch','on', 'Whisker',1,...
                'Labels',{'W', 'S1', 'S2', 'S3', 'S4', 'R'});
            
        if overlap_scatter == 'Y' || overlap_scatter == 'y'
            hold on;
            scat_data_x = [ones(length(scores_s1), 1).*(1+(rand(length(scores_s1), 1)-0.5)/10);...
                         2*ones(length(scores_s2), 1).*(1+(rand(length(scores_s2), 1)-0.5)/10);...
                         3*ones(length(scores_s3), 1).*(1+(rand(length(scores_s3), 1)-0.5)/10);...
                         4*ones(length(scores_s4), 1).*(1+(rand(length(scores_s4), 1)-0.5)/10);...
                         5*ones(length(scores_s5), 1).*(1+(rand(length(scores_s5), 1)-0.5)/10);...
                         6*ones(length(scores_s6), 1).*(1+(rand(length(scores_s6), 1)-0.5)/10)];
                     
            scatter(scat_data_x,...
                    [scores_s1; scores_s2; scores_s3; scores_s4; scores_s5; scores_s6],...
                    'b','MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);
                
            hold off;
        end
        
         ylim([0.5 1.025]);
         yticks([0.5 0.55 0.6 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]);

        title(strcat("Class probability distribution of the testing signal epochs: ", prep_labels(1, i)),...
            'interpreter','latex','FontUnits','points',...
            'FontWeight','demi','FontSize',18,'FontName','Times');

        xlabel('sleep stages','interpreter','latex','FontUnits','points',...
            'FontWeight','normal','FontSize',16,'FontName','Times');

        ylabel('class probabilities','interpreter','latex','FontUnits','points',...
            'FontWeight','normal','FontSize',16,'FontName','Times');

    end
    
elseif mode == 'N' || mode == 'n'
    
    score = score_cell{1, 1};

    gt_s1 = zeros(1, sum(P5stages == 5));
    gt_s2 = zeros(1, sum(P5stages == 4));
    gt_s3 = zeros(1, sum(P5stages == 3));
    gt_s4 = zeros(1, sum(P5stages == 2));
    gt_s5 = zeros(1, sum(P5stages == 1));
    gt_s6 = zeros(1, sum(P5stages == 0));

    ind_gt_s1 = find(P5stages == 5);
    ind_gt_s2 = find(P5stages == 4);
    ind_gt_s3 = find(P5stages == 3);
    ind_gt_s4 = find(P5stages == 2);
    ind_gt_s5 = find(P5stages == 1);
    ind_gt_s6 = find(P5stages == 0);

    scores_s1 = score(ind_gt_s1, 1);
    scores_s2 = score(ind_gt_s2, 1);
    scores_s3 = score(ind_gt_s3, 1);
    scores_s4 = score(ind_gt_s4, 1);
    scores_s5 = score(ind_gt_s5, 1);
    scores_s6 = score(ind_gt_s6, 1);

    g = [zeros(length(scores_s1), 1); ones(length(scores_s2), 1);...
         2*ones(length(scores_s3), 1); 3*ones(length(scores_s4), 1);...
         4*ones(length(scores_s5), 1); 5*ones(length(scores_s6), 1)];

    figure();
    boxplot([scores_s1; scores_s2; scores_s3; scores_s4; scores_s5; scores_s6],...
            g, 'Notch','on', 'Whisker',1,...
            'Labels',{'W', 'S1', 'S2', 'S3', 'S4', 'R'});
        
    if overlap_scatter == 'Y' || overlap_scatter == 'y'
        hold on;
        scat_data_x = [ones(length(scores_s1), 1).*(1+(rand(length(scores_s1), 1)-0.5)/10);...
                     2*ones(length(scores_s2), 1).*(1+(rand(length(scores_s2), 1)-0.5)/10);...
                     3*ones(length(scores_s3), 1).*(1+(rand(length(scores_s3), 1)-0.5)/10);...
                     4*ones(length(scores_s4), 1).*(1+(rand(length(scores_s4), 1)-0.5)/10);...
                     5*ones(length(scores_s5), 1).*(1+(rand(length(scores_s5), 1)-0.5)/10);...
                     6*ones(length(scores_s6), 1).*(1+(rand(length(scores_s6), 1)-0.5)/10)];

        scatter(scat_data_x,...
                [scores_s1; scores_s2; scores_s3; scores_s4; scores_s5; scores_s6],...
                'b','MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);

        hold off;
    end

     ylim([0.5 1.025]);
     yticks([0.5 0.55 0.6 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]);

    title(strcat("Class probability distribution of the testing signal epochs: ", prep_labels(1,  prep_ind)),...
        'interpreter','latex','FontUnits','points',...
        'FontWeight','demi','FontSize',18,'FontName','Times');

    xlabel('sleep stages','interpreter','latex','FontUnits','points',...
        'FontWeight','normal','FontSize',16,'FontName','Times');

    ylabel('class probabilities','interpreter','latex','FontUnits','points',...
        'FontWeight','normal','FontSize',16,'FontName','Times');

end


%% 3. Plotting sensitivities
% W=5
% S1=4
% S2=3
% S3=2
% S4=1
% REM=0

prep_labels = ["No Preprocessing", "ICA", "Filtering", "ICA $+$ Filtering"];

if mode == 'Y' || mode == 'y'
    color_pattern = [[0, 0.4470, 0.7410];...
                     [0.9290, 0.6940, 0.1250];...
                     [0.4660, 0.6740, 0.1880];...
                     [0.6350, 0.0780, 0.1840]];
                 
    ax = gobjects(4, 1);
    
    figure();
    for i = 1:4
        s1_ind = find(P5stages == 5); % W
        s2_ind = find(P5stages == 4); % S1
        s3_ind = find(P5stages == 3); % S2
        s4_ind = find(P5stages == 2); % S3
        s5_ind = find(P5stages == 1); % S4
        s6_ind = find(P5stages == 0); % REM

        confusion_result(1, 1) = sum(label_cell{i, 1}(s1_ind, 1) == 5) / length(label_cell{i, 1}(s1_ind, 1));
        confusion_result(2, 1) = sum(label_cell{i, 1}(s2_ind, 1) == 4) / length(label_cell{i, 1}(s2_ind, 1));
        confusion_result(3, 1) = sum(label_cell{i, 1}(s3_ind, 1) == 3) / length(label_cell{i, 1}(s3_ind, 1));
        confusion_result(4, 1) = sum(label_cell{i, 1}(s4_ind, 1) == 2) / length(label_cell{i, 1}(s4_ind, 1));
        confusion_result(5, 1) = sum(label_cell{i, 1}(s5_ind, 1) == 1) / length(label_cell{i, 1}(s5_ind, 1));
        confusion_result(6, 1) = sum(label_cell{i, 1}(s6_ind, 1) == 0) / length(label_cell{i, 1}(s6_ind, 1));

        ax(i, 1) = plot([1, 2, 3, 4, 5, 6], confusion_result', 'LineWidth', 2, 'Color', color_pattern(i, :)); hold on;
        scatter([1, 2, 3, 4, 5, 6], confusion_result', 70, 'LineWidth', 2, 'MarkerEdgeColor', color_pattern(i, :));
        
    end
        hold off;
        ylim([0 1.025]);
        xlim([1 6]);
        xticks([1 2 3 4 5 6]);
        xticklabels({'W', 'S1','S2', 'S3', 'S4', 'R'});
        grid on;
        grid minor;
        
        title("Classification sensitivity per sleep stage for all preprocessing settings",...
        'interpreter','latex','FontUnits','points',...
        'FontWeight','demi','FontSize',18,'FontName','Times');

        xlabel('sleep stages','interpreter','latex','FontUnits','points',...
        'FontWeight','normal','FontSize',16,'FontName','Times');

        ylabel('sensitivity','interpreter','latex','FontUnits','points',...
        'FontWeight','normal','FontSize',16,'FontName','Times');

        legend([ax(:)], prep_labels,...
               'interpreter',...
               'latex',...
               'FontWeight','normal',...
               'FontSize',10,...
               'FontName','Times',...
               'Orientation','Vertical',...
               'Location','SouthWest');
        
else
    
    s1_ind = find(P5stages == 5);
    s2_ind = find(P5stages == 4);
    s3_ind = find(P5stages == 3);
    s4_ind = find(P5stages == 2);
    s5_ind = find(P5stages == 1);
    s6_ind = find(P5stages == 0);

    confusion_result(1, 1) = sum(label_cell{1, 1}(s1_ind, 1) == 5) / length(label_cell{1, 1}(s1_ind, 1));
    confusion_result(2, 1) = sum(label_cell{1, 1}(s2_ind, 1) == 4) / length(label_cell{1, 1}(s2_ind, 1));
    confusion_result(3, 1) = sum(label_cell{1, 1}(s3_ind, 1) == 3) / length(label_cell{1, 1}(s3_ind, 1));
    confusion_result(4, 1) = sum(label_cell{1, 1}(s4_ind, 1) == 2) / length(label_cell{1, 1}(s4_ind, 1));
    confusion_result(5, 1) = sum(label_cell{1, 1}(s5_ind, 1) == 1) / length(label_cell{1, 1}(s5_ind, 1));
    confusion_result(6, 1) = sum(label_cell{1, 1}(s6_ind, 1) == 0) / length(label_cell{1, 1}(s6_ind, 1));

    figure();
    plot([1, 2, 3, 4, 5, 6], confusion_result'); hold on;
    scatter([1, 2, 3, 4, 5, 6], confusion_result');

    xlim([1 6]);
    xticks([1 2 3 4 5 6]);
    xticklabels({'W', 'S1','S2', 'S3', 'S4', 'R'});
    
    title(strcat("Classification sensitivity per sleep stage: ", prep_labels(1,  prep_ind)),...
    'interpreter','latex','FontUnits','points',...
    'FontWeight','demi','FontSize',18,'FontName','Times');

    xlabel('sleep stages','interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',16,'FontName','Times');

    ylabel('sensitivity','interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',16,'FontName','Times');

end

%% Scatter plots for segmentation boundary assessment 
% (2 features out of the 57 features of the higher space)

s1_inds = find(label_cell{1, 1}(:, 1) == 5);
s2_inds = find(label_cell{1, 1}(:, 1) == 3);


s1_feat1 = test_cell{1, 1}(s1_inds, 1);
s1_feat2 = test_cell{1, 1}(s1_inds, 2);

s2_feat1 = test_cell{1, 1}(s2_inds, 1);
s2_feat2 = test_cell{1, 1}(s2_inds, 2);

figure();
scatter(s1_feat1, s1_feat2, 'b.'); hold on;
scatter(s2_feat1, s2_feat2, 'r.'); hold off;
xlabel('feature 1');
ylabel('feature 2');
legend('W stage', 'S2 stage');

% gscatter(test_cell{1, 1}(:, 1),test_cell{1, 1}(:, 2), label_cell{1, 1}(:, 1), 'ymcrgb', '.',5);% , 'MarkerSize', 10);
% axis tight
% legend off


%% (DEPRECATED) Plotting a boxplot using data chunks of predictors

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
