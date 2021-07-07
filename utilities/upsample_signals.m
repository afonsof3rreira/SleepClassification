function resampled_signal = upsample_signals(input_signal, signal_sub_header, sub_ib, max_sf, sub_time_mat)
% INPUT:
    % input_signal: raw signal containing selected subsignals
    % time_mat: Mat containing time vectors of the original raw signals
    % signal_header: header of the raw signals
    % Indices of common signals in the signal_header: ib
    % Mat containing maximum sampling frequencies of each signal type: max_sfs
    
% OUTPUT:
    % Upsampled original raw signals: n1_, n2_, n3_, n5_, n11_
    
resampled_signal = zeros(size(input_signal, 1), size(input_signal, 2));
% disp(size(sub_time_mat{1, 1}));

for j = 1: size(input_signal, 1)
    if signal_sub_header.samples(sub_ib(1, j)) ~= max(max_sf)
        disp(signal_sub_header.label(sub_ib(1, j)));
        sf = max(max_sf);
        l = size(sub_time_mat{j, 1}, 2);
        factor = sf/signal_sub_header.samples(sub_ib(1, j));
        resampled_signal(j, :) = resample(input_signal(j, 1:l), factor, 1);
    else
        disp(signal_sub_header.label(sub_ib(1, j)));
        resampled_signal(j, :) = input_signal(j, :);
    end

end
