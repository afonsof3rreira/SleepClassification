function plot_signals(signal_arr, time_mat, signal_names, selection_info, whole_sample)
% INPUT:
% signal_arr: signals in an array [n1, n2, n3, n5, n11].
% time_mat: mat containing time vectors.
% whole_sample: if true, plots the whole signal, otherwise, a 30-second
% epoch is plotted.

for i = 1:5
    sub_time_mat = time_mat{i, 1};
    
    figure();
    for j = 1: 9
        time_vec = sub_time_mat{j, 1};
        subplot(9, 1, j);
        
        if whole_sample
            time_cropped = size(time_vec, 2);
        else
            time_cropped = find(time_vec==30);
        end
        signal = signal_arr(i, :);
        plot(time_vec(1:time_cropped), signal(j, 1:time_cropped));

        title(selection_info(1, j) + " " + num2str(1/time_vec(2)));
    end
    
    sgtitle("Signal " + signal_names(i));
    xlabel("time [s]");
end

end