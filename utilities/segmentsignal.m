function [epochs]=segmentsignal(signal,fs)
signal= signal(any(signal,2),:);
epochnumber=length(signal)/(30*fs);
epochs=zeros(round(epochnumber),30*fs);
for i=1:epochnumber
    epochs(i,:)=signal(i*30*fs-30*fs+1:i*30*fs);
end
epochs= epochs(any(epochs,2),:);
lastnumber=epochs(end,end);
while lastnumber==0
    epochs=epochs(1:end-1,:);
    lastnumber=epochs(end,end);
end
end