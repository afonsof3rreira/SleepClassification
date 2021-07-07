function denormalized_signal = denorm_signals(normalized_signal, mean_data, mu_data, ind)

denormalized_signal = normalized_signal.*mean_data(ind, :)' + mu_data(ind, :)';
disp("Signal " + num2str(ind) + "/5 done.");

end
