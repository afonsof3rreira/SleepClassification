function [processed_signal] = process_signals_nolow(signal, highpass_filter, notch_filter)
% Filters used: (sf = 512 Hz, check signal before using)
% IIR Butterworth Highpass Filter 0.5 Hz, 4th order
% Single notch filter 50 Hz, 2nd order
    
    % Highpass filter 0.5 Hz
    [b_high,a_high] = tf(highpass_filter);
    processed_signal = filter(b_high,a_high,signal);
    
    % Notch filter 50 Hz
    [b_notch,a_notch] = tf(notch_filter);
    processed_signal = filter(b_notch,a_notch,processed_signal);
end
