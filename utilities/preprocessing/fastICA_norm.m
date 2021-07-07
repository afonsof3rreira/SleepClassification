function [fastica_result, input_signal, mu_data, mean_data] = fastICA_norm(input_signal, mu_data, mean_data, ind)
% INPUT:
    % Upsampled original raw signals: n1_, n2_, n3_, n5_, n11_
    
% OUTPUT:
    % StD. data of the upsampled unormalized data: mu_data
    % Mean data of the upsampled unormalized data: mean_data
    % Fast ICA results:  fastica_result_n1, ..., fastica_result_n11

% Process:
% 1) picking upsampled signals e.g. Z = n1_;
% 2) Performing zscore normalization, saving original StD. and Mean on mat
% files;
% 3) Performing ICA, saving the results in structures;

disp("performing z-score normalization..." + newline);
[input_signal, mu_data(ind, :), mean_data(ind, :)] = zscore(input_signal'); % mean => 0, St.D. => 1

disp("performing ICA..." + newline);
input_signal=input_signal';
[Xe, A, W] = fastica (input_signal);

fastica_result = struct;

switch ind
    case 1
        fastica_result.Xe_n1 = Xe;
        fastica_result.A_n1 = A;
        fastica_result.W_n1 = W;
    case 2
        fastica_result.Xe_n2 = Xe;
        fastica_result.A_n2 = A;
        fastica_result.W_n2 = W;
    case 3
        fastica_result.Xe_n3 = Xe;
        fastica_result.A_n3 = A;
        fastica_result.W_n3 = W;
    case 4
        fastica_result.Xe_n5 = Xe;
        fastica_result.A_n5 = A;
        fastica_result.W_n5 = W;
    case 5
        fastica_result.Xe_n11 = Xe;
        fastica_result.A_n11 = A;
        fastica_result.W_n11 = W;
end

end