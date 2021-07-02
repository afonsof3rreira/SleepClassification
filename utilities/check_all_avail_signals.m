function [labels, transducers] = check_all_avail_signals(signal_header)

starting_labels = convertCharsToStrings(signal_header{1,1}.label);
list_avail_signals = strings(1, 30);
starting_transds = convertCharsToStrings(signal_header{1,1}.transducer);
list_avail_transd = strings(1, 30);

list_avail_signals(1, 1:length(starting_labels)) = starting_labels;
list_avail_transd(1, 1:length(starting_transds)) = starting_transds;

for i = 2: size(signal_header, 1)
    temp_labels = convertCharsToStrings(signal_header{i,1}.label);
    temp_transducers = convertCharsToStrings(signal_header{i,1}.transducer);
    
    [cs, ias] = setdiff(temp_labels, list_avail_signals);

    len_filled1 = length(list_avail_signals(list_avail_signals(:) ~= ""));
    len_filled2 = length(list_avail_transd(list_avail_transd(:) ~= ""));

    cs = cs(cs(:) ~= "");
    
    list_avail_signals(1, len_filled1 +1: len_filled1 + length(cs)) = cs;
    list_avail_transd(1, len_filled2 +1: len_filled2 + length(temp_transducers(ias))) = temp_transducers(ias);
    
end

labels = list_avail_signals(list_avail_signals(:) ~= "");
transducers = list_avail_transd(list_avail_transd(:) ~= "");

eeg_count = sum(contains(transducers, "EEG"));
other_transds = transducers(~contains(transducers, "EEG"));


nrep_other_transds = unique(other_transds); 
char_cell = convertStringsToChars(deblank(nrep_other_transds));

nrep_other_transds_count = strings(1, size(nrep_other_transds, 2));


all_transducers = {};
all_transducers{1, 1} = 'EEG';
for i = 2 : length(nrep_other_transds)+1
    all_transducers{1, i} = char_cell{i-1};
end


for i = 1: length(nrep_other_transds)
    temp_transd = nrep_other_transds(1, i);
    nrep_other_transds_count(1, i) = sum(contains(transducers, nrep_other_transds(1, i)));
end

total_count = str2double([eeg_count; nrep_other_transds_count(1, :)'])';

disp("The number of signals found for all transducer types is:");
T = array2table(total_count,'VariableNames',all_transducers,'RowName',{'Count'}); 
disp(T) 

end