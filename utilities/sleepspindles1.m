function [ss] = sleepspindles1(EEG,sf)
ss=bandpower(EEG,sf,[10 16]);
end

