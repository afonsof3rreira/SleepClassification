function check_all_durations(signal_header)

durations = strings(1, size(signal_header, 1));

for i = 1: size(signal_header, 1)
    s = seconds(signal_header{i,1}.records * signal_header{i,1}.duration);   
    s.Format = 'hh:mm:ss';
    durations(1, i) = convertCharsToStrings(s);
end

disp("The number of signals found for all transducer types is:");
T = array2table(convertStringsToChars(durations),'VariableNames',{'n1', 'n2', 'n3', 'n5', 'n11'},'RowName',{'Count'}); 
disp(T)

end