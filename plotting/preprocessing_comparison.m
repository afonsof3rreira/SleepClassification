%% PREPROCESSING COMPARISON (Used for the papper)
% This script was used to generate a plot to allow comparing different
% preprocessing steps of the pipeline, including raw signals.
% While in the main script plots were used to confirm the desired outputs,
% here we plot the signals aesthetically.

%% 1. loading signals
% Change variables names to be loaded

signal_ind = input('Input the patient number from 1 to 5: ');
signal_names = ["n1", "n2", "n3", "n5", "n11"];


disp("loading mat files...");
signal_raw_path = strcat("./data/resampled_signals/", signal_names(signal_ind), "_.mat");
signal_ICA_path = strcat('./data/resampled_signals/EOG_filt/', signal_names(signal_ind), "_ef", ".mat");
signal_filt_path = strcat('./Filters/', signal_names(signal_ind), "p", ".mat");

load('./data/raw_data/mat_files/selection_info.mat'); disp("selection info loaded")
load('./data/raw_data/mat_files/signal_header.mat'); disp("signal header loaded")
load('./data/resampled_signals/time_vec.mat'); disp("time vector loaded")
s_raw = load(signal_raw_path); disp("raw signal loaded");
s_ica = load(signal_ICA_path); disp("ICA EOG-filtered signals loaded");
s_filt = load(signal_filt_path); disp("ICA + LP / HP filtered signals loaded");

switch signal_ind
    case 1
        s_raw = s_raw.n1_;
        s_ica = s_ica.n1_ef;
        s_filt = s_filt.n1p;
    case 2
        s_raw = s_raw.n2_;
        s_ica = s_ica.n2_ef;
        s_filt = s_filt.n2p;
    case 3
        s_raw = s_raw.n3_;
        s_ica = s_ica.n3_ef;
        s_filt = s_filt.n3p;
    case 4
        s_raw = s_raw.n5_;
        s_ica = s_ica.n5_ef;
        s_filt = s_filt.n5p;
    case 5
        s_raw = s_raw.n11_;
        s_ica = s_ica.n11_ef;
        s_filt = s_filt.n11p;
end


clear signal_raw_path signal_ICA_path signal_filt_path

%% 2. Prompting the user
% Prompts -----------------------------------------------------------------
st_ind = input("Input the signal type as a number from 1 to 9: ");
disp(newline + "Input the following time axis params for plotting:");
start_t = input('starting time in seconds: ');
duration = input('duration in seconds: ');
% ----------------------------------------------------------------- Prompts
ib = find(signal_header{signal_ind, 1}.label == selection_info(1, st_ind));
%
unit = replace(signal_header{signal_ind, 1}.units{1, ib}, 'u', '$\mu$');

%% 3. Plotting

ts = time_vec(1, 2);

ind_i = find(time_vec == start_t);
ind_f = find(time_vec == (start_t + duration));

max_y = max([max(s_raw(st_ind, ind_i:ind_f)), max(s_ica(st_ind, ind_i:ind_f)), max(s_raw(st_ind, ind_i:ind_f), s_filt(st_ind, ind_i:ind_f))]);
min_y = min([min(s_raw(st_ind, ind_i:ind_f)), min(s_ica(st_ind, ind_i:ind_f)), min(s_raw(st_ind, ind_i:ind_f), s_filt(st_ind, ind_i:ind_f))]);

max_y = 10*ceil((max_y)/10);
min_y = 10*ceil((min_y)/10);

var_max_y = abs(10*ceil((max_y * 0.25)/10));
var_min_y = abs(10*ceil((min_y * 0.25)/10));

fig = figure();
ax = gobjects(3, 1);
sub_ax_1 = gobjects(2, 1);

ax(1, 1) = subplot(2, 1, 1);
sub_ax_1(1, 1) = plot(time_vec(1, ind_i:ind_f), s_raw(st_ind, ind_i:ind_f)); hold on;
sub_ax_1(2, 1) = plot(time_vec(1, ind_i:ind_f), s_ica(st_ind, ind_i:ind_f)); hold off;
grid on;
grid minor;

title('ICA filtering','interpreter','latex','FontUnits','points',...
    'FontWeight','demi','FontSize',18,'FontName','Times');

xlabel('time [s]','interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',12,'FontName','Times');
str_amp = strcat('Amplitude [',unit,']');
ylabel(str_amp,'interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',12,'FontName','Times');

legend([sub_ax_1(1, 1) sub_ax_1(2, 1)],...
                    'Raw signal','ICA EOG-filtered',...
                    'interpreter',...
                    'latex',...
                    'FontWeight','normal',...
                    'FontSize',10,...
                    'FontName','Times',...
                    'Orientation','Horizontal',...
                    'Location','SouthEast');
                
ylim([min_y - var_min_y, max_y + var_max_y]);
                
ax(2, 1) = subplot(2, 1, 2);
sub_ax_1(1, 1) = plot(time_vec(1, ind_i:ind_f), s_raw(st_ind, ind_i:ind_f)); hold on;
sub_ax_1(2, 1) = plot(time_vec(1, ind_i:ind_f), s_filt(st_ind, ind_i:ind_f)); hold off;
grid on;
grid minor;

title('ICA, HP and LP filtering','interpreter','latex','FontUnits','points',...
    'FontWeight','demi','FontSize',18,'FontName','Times');

xlabel('time [s]','interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',12,'FontName','Times');
str_amp = strcat('Amplitude [',unit,']');
ylabel(str_amp,'interpreter','latex','FontUnits','points',...
    'FontWeight','normal','FontSize',12,'FontName','Times');

legend([sub_ax_1(1, 1) sub_ax_1(2, 1)],...
                    'Raw signal','ICA EOG-, HP- and LP-filtered',...
                    'interpreter',...
                    'latex',...
                    'FontWeight','normal',...
                    'FontSize',10,...
                    'FontName','Times',...
                    'Orientation','Horizontal',...
                    'Location','SouthEast');
                
ylim([min_y - var_min_y, max_y + var_max_y]);

sg_title_str = strcat("Signal type: ",selection_info(1, st_ind));
sgtitle(sg_title_str,'interpreter','latex','FontUnits','points',...
        'FontWeight','demi','FontSize',18,'FontName','Times');

