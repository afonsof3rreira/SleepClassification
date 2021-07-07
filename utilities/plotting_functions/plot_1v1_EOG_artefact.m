function plot_1v1_EOG_artefact(input_signal_1, input_signal_2, time_vec, last_t_ind, signal_name, selection_info)
    
figure();
sgtitle(signal_name);

ax = gobjects(9, 1);

for i = 1 : 9

    ax(i) = subplot(size(input_signal_1, 1), 1, i);
    plot(time_vec(1:last_t_ind), input_signal_1(i, 1:last_t_ind)); hold on;
    plot(time_vec(1:last_t_ind), input_signal_2(i, 1:last_t_ind)); hold off;

    title(selection_info(1, i) + " " + num2str(1/time_vec(1, 2)));
end

linkaxes([ax], 'x');

end