function eog_cleaned_signal = EOG_ICA_removal(fastica_result, normalized_signal, eog_inds, reset_signals, ind)

disp("removing EOG components...");

switch ind
    case 1
        G = fastica_result.A_n1;
        G(:, eog_inds(1, ind)) = 0; 
        eog_cleaned_signal = G*fastica_result.Xe_n1;
    case 2
        G = fastica_result.A_n2;
        G(:, eog_inds(1, ind)) = 0; 
        eog_cleaned_signal = G*fastica_result.Xe_n2;
    case 3 
        G = fastica_result.A_n3;
        G(:, eog_inds(1, ind)) = 0; 
        eog_cleaned_signal = G*fastica_result.Xe_n3;
    case 4
        G = fastica_result.A_n5;
        G(:, eog_inds(1, ind)) = 0; 
        eog_cleaned_signal = G*fastica_result.Xe_n5;
    case 5
        G = fastica_result.A_n11;
        G(:, eog_inds(1, ind)) = 0; 
        eog_cleaned_signal = G*fastica_result.Xe_n11;
end

% resetting all non-EEG indices
disp("resetting all non-EEG signals back to the original resampled states...");

eog_cleaned_signal(reset_signals(:), :) = normalized_signal(reset_signals(:), :);

end