function max_sfs = check_s_freqs(common_indices, signal_header)
% INPUTS:
% common_indices: 
% Nr of Signals x Nr of Common Sub-signals

% signal_header: 
% Nr of Signals x 1 -> fields -> samples: 1 x Total Nr of Avalable Signals

common_labs = {};
labels = signal_header{1, 1}.label;

for i = 1: size(common_indices, 2)
    nr = common_indices(1, i);
    common_labs{1, i} = labels{1, nr};
end

sfds = zeros(size(common_indices, 1), size(common_indices, 2));

for i = 1 : size(common_indices, 1)
    for j = 1 : size(common_indices, 2)
        sfds(i, j) =  signal_header{i, 1}.samples(common_indices(i, j));
    end
end

max_sfs = max(sfds);

disp("The sampling frequencies for all common signal types in each signal are:" + newline);
T = array2table([sfds; max_sfs],'VariableNames',common_labs,'RowName',{'n1', 'n2', 'n3', 'n5', 'n11', 'max sf'}); 
disp(T) 

end
