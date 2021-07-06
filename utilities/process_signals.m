function [processed_signal] = process_signals(signal, highpass_filter, ...
    lowpass_filter, notch_filter)
% Filters used: (sf = 512 Hz, check signal before using)
% IIR Butterworth Highpass Filter 0.5 Hz, 4th order
% IIR Butterworth Lowpass filter 200 Hz, 4th order
% Single notch filter 50 Hz, 2nd order
    
    % Highpass filter 0.5 Hz
    [b_high,a_high] = tf(highpass_filter);
    processed_signal = filter(b_high,a_high,signal);
    
    % Lowpass filter 200 Hz
    [b_low,a_low] = tf(lowpass_filter);
    processed_signal = filter(b_low,a_low,processed_signal);
    
    % Notch filter 50 Hz
    [b_notch,a_notch] = tf(notch_filter);
    processed_signal = filter(b_notch,a_notch,processed_signal);
end
