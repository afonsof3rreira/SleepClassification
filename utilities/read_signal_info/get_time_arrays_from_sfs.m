function time_mat = get_time_arrays_from_sfs(signal_header, sampling_freqs)
disp("Computing time arrays of the original selected signals...");

time_mat = cell(5, 1);

for i = 1: length(signal_header)
    n_records = signal_header{i, 1}.records;
    n_duration = signal_header{i, 1}.duration;
    tot_duration = n_records * n_duration;
    vals = cell(9, 1);
    for j = 1 : 9
%         sf = signal_header{i, 1}.samples(1, ib(i, j));
        sf = sampling_freqs(i, j);
        ts = 1 / sf; %  str2num(selection_info(3, j));
        vals{j, 1} = 0: ts: tot_duration - ts;
    end
    time_mat{i, 1} = vals;
    disp("signal " + num2str(i) + "/" + num2str(length(signal_header)) + " done.");
end

end