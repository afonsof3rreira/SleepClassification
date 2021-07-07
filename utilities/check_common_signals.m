function [common_labels, common_transducers] = check_common_signals(signal_header)

j = 1;
common_labels = convertCharsToStrings(signal_header{j,1}.label);
    
for i = j + 1: size(signal_header, 1)
    temp_labels = convertCharsToStrings(signal_header{i,1}.label);
    common_labels = intersect(common_labels, temp_labels);
end

labels_example = convertCharsToStrings(signal_header{j,1}.label);
[~,~,ib] = intersect(common_labels, labels_example);

common_transducers = convertCharsToStrings(signal_header{j,1}.transducer);

common_transducers = common_transducers(1, ib(:, 1));

end
