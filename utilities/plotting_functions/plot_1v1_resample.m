function plot_1v1_resample(input_signal_1, input_signal_2, sub_time_mat, signal_name, selection_info, whole_sample, scatter_bool, time_lim)

figure(); 

for j = 1: 9
    time_vec_1 = sub_time_mat{j, 1};
    time_vec_2 = sub_time_mat{1, 1};
    
    ax(j) = subplot(9, 1, j);

    if whole_sample
        time_cropped_1 = size(time_vec_1, 2);
        time_cropped_2 = size(time_vec_2, 2);
    else
        time_cropped_1 = round(find(time_vec_1(1, :)==time_lim));
        time_cropped_2 = round(find(time_vec_2(1, :)==time_lim));
    end
    
    if scatter_bool
        x = linspace(1, 10, 100);
        scatter(time_vec_2(1, 1:time_cropped_2), input_signal_2(j, 1:time_cropped_2)); hold on;
        scatter(time_vec_1(1, 1:time_cropped_1), input_signal_1(j, 1:time_cropped_1)); hold off;
    else
        plot(time_vec_2(1, 1:time_cropped_2), input_signal_2(j, 1:time_cropped_2)); hold on;
        plot(time_vec_1(1, 1:time_cropped_1), input_signal_1(j, 1:time_cropped_1)); hold off;
    end
    title(selection_info(1, j) + " " + num2str(1/time_vec_1(1, 2)));
end

linkaxes(ax(:));
sgtitle("Signal " + signal_name);
xlabel("time [s]");
clear ax

end